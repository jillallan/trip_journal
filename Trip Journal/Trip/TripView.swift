//
//  Trip2View.swift
//  Trip Journal
//
//  Created by Jill Allan on 10/12/2022.
//

import CoreData
import MapKit
import SwiftUI

struct TripView: View {
    
    // MARK: - Properties

    let trip: Trip
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    
    @State var longitude = 0.0
    @State var latitude = 51.5
    
    @State var coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    @State var span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    @State var currentMapRegion: MKCoordinateRegion!
    
    @FetchRequest var steps: FetchedResults<Step>
    @FetchRequest var locations: FetchedResults<Location>
    @State var tripRoute = [MKPolyline]()
    @State var featureAnnotation: MKMapFeatureAnnotation!
    @State var selectedAnnotation: Location!
    
    @State var displayedSteps: [Step] = []
    @State var addViewIsPresented: Bool = false
    @State private var locationViewIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var animationAmount = 1.0
    
    // MARK: - Init
    
    init(trip: Trip) {
        self.trip = trip
        
        let tripStartPredicate = NSPredicate(format: "timestamp > %@", trip.tripStartDate as CVarArg)
        let tripEndPredicate = NSPredicate(format: "timestamp < %@", trip.tripEndDate as CVarArg)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [tripStartPredicate, tripEndPredicate])
        
        _locations = FetchRequest<Location>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
            predicate: compoundPredicate
        )
        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
        
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    
                    // MARK: - Map View
                    ZStack {
                        
                        MapView(
                            coordinateRegion: MKCoordinateRegion(
                                center: coordinate,
                                span: span
                            ),
                            annotationItems: locations.map { $0 },
                            routeOverlay: createRoute(from: locations.map(\.coordinate)), onAnnotationSelection:  { annotation in
                                selectedAnnotation = annotation as? Location
                                locationViewIsPresented = true
                                
                            })
                    }
                    .onAppear {
                        print("steps count: \(steps.count)")
                        print("locations count: \(locations.count)")
                    }
                    .frame(height: geo.size.height * 0.65)
                    
                    .confirmationDialog("Location", isPresented: $locationViewIsPresented, actions: {
                        if let selectedAnnotation = selectedAnnotation {
                            if let location = locations.first(where: { $0 == selectedAnnotation }) {
                                if let step = location.step {
                                    Button("Delete Step") {
                                        delete(step)
                                    }
                                } else {
                                    Button("Add Step ") {
                                        // TODO: -
                                    }
                                    Button("Delete Location") {
                                        delete(location)
                                    }
                                }
                            }
                        }
                    }, message: {
                        if let selectedAnnotation = selectedAnnotation {
                            // TODO: - location lookup
                            Text(selectedAnnotation.step?.stepName ?? String(describing: selectedAnnotation.locationTimestamp))
                        }
                        
                    })
            
                    // MARK: - Step Scroll view
                    
                    ScrollView(.horizontal) {
                        
                        LazyHGrid(rows: [GridItem()], spacing: 1) {
                            TripTitleCard(trip: trip)
                                .onAppear {
                                    if locations.count < 1 {
                                        if let currentLocation = locationManager.currentLocation?.coordinate {
                                            coordinate = currentLocation
                                        }
                                    } else {
                                        coordinate = calculateTripRegion(from: locations).center
                                        span = calculateTripRegion(from: locations).span
                                    }
                                }
                            
                            Rectangle().frame(width: 1).hidden()
                            
                            
                            ForEach(steps) { step in
                                
                                ZStack {
//                                    
                                    NavigationLink {
                                        StepView(step: step)
                                    } label: {
                                        StepCard(step: step)
                                    }

                                    
                         
                                    
                                    Button {
                                        // TODO: - pass step timestamp to add new step just after
                                        // TODO: - Once location tracking is enabled add suggestions to add step view, based on timestamp and timestamp of next step
                                        addViewIsPresented.toggle()
                                    } label: {
                                        Label("Add", systemImage: "plus")
                                            .addButtonStyle()
                                    }
                                    .offset(x: -175)
                                    
                                }
                                Rectangle()
                                    .frame(width: 1)
                                    .hidden()
                                    .onAppear {
                                        displayedSteps = add(step, to: displayedSteps)
                                    }
                            }
                            
                            Button {
                                addViewIsPresented.toggle()
                            } label: {
                                Label("Add", systemImage: "plus")
                                    .addButtonStyle()
                            }
                            .offset(x: -15)
                        }
                    }
//                    .padding()
                    .frame(height: geo.size.height * 0.3)
                }
            }
            
            // MARK: - Navigation
            .navigationTitle(trip.tripTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        delete(trip)
                        dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                }
            }
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $addViewIsPresented) {
                AddStepView(coordinate: coordinate, trip: trip)
            }
          
            .onChange(of: displayedSteps) { newStepsArray in
                if !newStepsArray.isEmpty {
                    coordinate = updateRegionCoordinates(with: newStepsArray)
                }
            }
            .onChange(of: locationManager.currentLocation) { newLocation in
                if let currentLocation = newLocation?.coordinate {
                    coordinate = currentLocation
                }
            }
            .onDisappear {
                dataController.save()
            }
        }
    }
    
    // MARK: - Update view
    
    private func calculateTripRegion(from locations: FetchedResults<Location>) -> MKCoordinateRegion {
        let minLatitude = locations.map(\.coordinate.latitude).min() ?? 0.0
        let maxLatitude = locations.map(\.coordinate.latitude).max() ?? 0.0
        let minLongitude = locations.map(\.coordinate.longitude).min() ?? 0.0
        let maxLongitude = locations.map(\.coordinate.longitude).max() ?? 0.0

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLatitude - minLatitude) * 1.2,
            longitudeDelta: (maxLongitude - minLongitude) * 1.2
        )
    
        return MKCoordinateRegion(center: center, span: span)
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
    
    func remove(_ step: Step, from array: [Step]) -> [Step] {
        var newArray = array
        if let firstStepTimestamp = array.first?.stepTimestamp {
            if step.stepTimestamp == firstStepTimestamp {
                newArray.remove(at: 0)
            } else {
                let lastIndex = newArray.index(before: newArray.endIndex)
                newArray.remove(at: lastIndex)
            }
        }
        return newArray
    }
    
    func add(_ step: Step, to array: [Step]) -> [Step] {
        var newArray = array
        
        if newArray.isEmpty {
            newArray.append(step)
        } else {
            if let lastStepTimestamp = newArray.last?.stepTimestamp {
                
                if step.stepTimestamp > lastStepTimestamp {
                    newArray.append(step)
                    newArray.remove(at: 0)
                } else {
                    newArray.insert(step, at: 0)
                    newArray.removeLast()
                }
            }
        }
        return newArray
    }
    
    func updateRegionCoordinates(with steps: [Step]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: steps[0].latitude,
            longitude: steps[0].longitude
        )
    }
    
    // MARK: - Update Model
    
//    func addStep(for location: Location, name: String) {
//        if let stepLocation = placemark.location {
//            
//            let location = Location(context: dataController.container.viewContext, cLlocation: stepLocation)
//            
//            let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: location.locationTimestamp, name: name)
//            
//            location.trip = trip
//            location.step = step
//            dataController.save()
//        } else {
//            print("Failed to add step")
//        }
//    }
    
    func updateTrip(with locations: [Location]) -> NSBatchUpdateRequest {
        let batchUpdate = NSBatchUpdateRequest(entity: Location.entity())
        return batchUpdate
    }
    
//    func updateTrip() {
//        // TODO: - Navigating back to tripView does not refresh view
//
//        trip.title = name
//        trip.startDate = startDate
//        trip.endDate = endDate
//    }
    
    func delete(_ location: Location) {
//        location.step = nil
        dataController.delete(location)
        dataController.save()
    }
    
    func deleteSteps(at offsets: IndexSet) {
        for offset in offsets {
            let step = steps[offset]
            delete(step)
        }
        dataController.save()
    }
    
    func delete(_ trip: Trip) {
        for step in trip.tripSteps {
            delete(step)
        }
        dataController.delete(trip)
        dataController.save()
    }
    
    func delete(_ step: Step) {
        if let location = step.location {
            if location.distance == 0 && location.horizontalAccuracy == 0 {
                delete(location)
            }
            dataController.delete(step)
        }
        dataController.save()
    }
}

//struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip: .preview)
//    }
//}
