//
//  TripViewMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct Trip2View: View {
    
    // MARK: - Properties
    
    let trip: Trip
    
    @FetchRequest var steps: FetchedResults<Step>
    @State var tripRoute = [MKPolyline]()
    @State var region: MKCoordinateRegion

    
    @State var featureAnnotation: MKMapFeatureAnnotation!
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager

    @State var addViewIsPresented: Bool = false
    @State var mapTypeConfirmationDialogIsPresented = false
    @State var mapConfiguration: MKMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
    @State var currentMapRegion: MKCoordinateRegion!
    
    // MARK: - Init
    
    init(trip: Trip) {
        self.trip = trip
        let region = trip.region
        
        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
        _region = State(initialValue: region)
 
        
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geo in
                VStack {
                    Text("\(region.center.latitude)")
                    MapView(
                        coordinateRegion: region,
                        annotationItems: steps.map({ step in
                            step
                        }),
                        routeOverlay: createRoute(from: steps.map(\.coordinate))
                    ) { region in
                        currentMapRegion = region
                    }
                    .frame(height: geo.size.height * 0.75)
                    
                    let _ = Self._printChanges()
                    let _ = print(region)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.flexible(), spacing: 20)], spacing: 20) {
                            ForEach(steps) { step in
                                NavigationLink {
                                    StepView(step: step)
                                } label: {
                                    StepCard(step: step, geometry: geo)
                                        .cornerRadius(12)
                                        .clipped(antialiased: true)
                                        
                                        .onAppear {
                                            getRegion(for: step)
                                       
                                       
                                        }
//                                        .onChange(of: currentStep) { newStep in
//                                            region = getRegion(for: newStep)
//                                        }
                                        

                                        
                                }
                            }
                            .onDelete { indexSet in
                                deleteSteps(at: indexSet)
                            }
                        }.padding(.bottom, 20)
                    }
                    .frame(height: geo.size.height * 0.25)
                    .padding(10)
                    .onDisappear {
                        region = currentMapRegion
                    }
                }
            }
            .sheet(isPresented: $addViewIsPresented) {
                // On dismiss of addView
                region = getRegionForLastStep()
            } content: {
                AddStepView(coordinate: region.center, trip: trip)
            }
            .toolbar {
                Button {
                    region = currentMapRegion
                    addViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle(trip.tripTitle)
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Choose map", isPresented: $mapTypeConfirmationDialogIsPresented) {
                Button("Standard") {
                    mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
                }
                Button("Hybrid") {
                    mapConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
                }
                Button("Satellite") {
                    mapConfiguration = MKImageryMapConfiguration()
                }
            } message: {
                Text("Choose a map from here")
            }
            
//            .onAppear {
//                region = calculateMapRegion(from: steps.map(\.coordinate))
//            }
        }
    }
    
    func deleteSteps(at offsets: IndexSet) {
        
        for offset in offsets {
            let step = steps[offset]
            dataController.delete(step)
        }
        dataController.save()
    }
    
    func getRegionForLastStep() -> MKCoordinateRegion {
        var region = MKCoordinateRegion()
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        if let center = steps.last?.coordinate {
            region = MKCoordinateRegion(center: center, span: span)
        }
        return region
    }
    
    func getRegion(for step: Step) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let center = step.coordinate
        print("getRegion fr step \(MKCoordinateRegion(center: center, span: span))")

//        return MKCoordinateRegion(center: center, span: span)
        region = MKCoordinateRegion(center: center, span: span)
    }
    
    func createRoute(from coordinates: [CLLocationCoordinate2D]) -> [MKPolyline] {
        var route = [MKPolyline]()

        if !coordinates.isEmpty {
            var tripRouteStart = coordinates
            var tripRouteEnd = coordinates
            
            tripRouteStart.removeLast()
            tripRouteEnd.removeFirst()
            
            for (startCoordinate, endCoordinate) in zip(tripRouteStart, tripRouteEnd) {
                let polyline = MKPolyline(coordinates: [startCoordinate, endCoordinate], count: 2)
                route.append(polyline)
                
            }
        }
        return route
    }
    
    func calculateMapRegion(from coordinate: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        
        if let maxLatitude = coordinate.map(\.latitude).max(),
           let minLatitude = coordinate.map(\.latitude).min(),
           let maxLongitude = coordinate.map(\.longitude).max(),
           let minLongitude = coordinate.map(\.longitude).min() {
            let centre = calculateCentreCoordinate(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            let span = calculateCoordinateSpan(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            return MKCoordinateRegion(center: centre, span: span)
        } else {
            return calculateMapRegionWihLocale()
        }
    }
    
    private func calculateCentreCoordinate(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
    }
    
    private func calculateCoordinateSpan(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> MKCoordinateSpan {
        return MKCoordinateSpan(
            latitudeDelta: (maxLatitude - minLatitude) * 1.2,
            longitudeDelta: (maxLongitude - minLongitude) * 1.2
        )
    }
    
    func calculateMapRegionWihLocale() -> MKCoordinateRegion {
        // TODO: - Hardcode coordinates for all 7 continents

        let locale = Locale.current
        var centre = CLLocationCoordinate2D()
        let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        var region = MKCoordinateRegion()

        if let regionCode = locale.language.region?.identifier {
            locationManager.fetchPlacemark(for: regionCode)
            if let coordinates = locationManager.fetchedPlacemark?.location?.coordinate {
                centre = coordinates
            } else {
                centre = CLLocationCoordinate2D(latitude: 60.0, longitude: -5.5)
            }
        } else {
            centre = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
        }
        region = MKCoordinateRegion(center: centre, span: span)
        return region
    }
}

// MARK: - Xcode Preview

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: .preview)
    }
}

//VStack() {
//    HStack() {
//        Spacer()
//        Button {
//            mapTypeConfirmationDialogIsPresented.toggle()
//        } label: {
//            Label("Map Type", systemImage: "map")
//
//        }
//        .padding()
//        .tint(.gray)
//        .buttonStyle(.borderedProminent)
//        .buttonBorderShape(.roundedRectangle)
//    }
//    Spacer()
//}
