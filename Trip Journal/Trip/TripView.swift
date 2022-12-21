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
    @State var name: String
    
    @State var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 51.5)
    @State var currentMapRegion: MKCoordinateRegion!
    
    @FetchRequest var steps: FetchedResults<Step>
    @State var tripRoute = [MKPolyline]()
    @State var featureAnnotation: MKMapFeatureAnnotation!
    
    @State var displayedSteps: [Step] = []
    @State var addViewIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Init
    
    init(trip: Trip) {
        self.trip = trip
        _name = State(initialValue: trip.tripTitle)
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
                    MapView(
                        coordinateRegion: MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        ),
                        annotationItems: steps.map { $0 },
                        routeOverlay: createRoute(from: steps.map(\.coordinate))
                    )
                    .frame(height: geo.size.height * 0.7)
            
                    // MARK: - Step Scroll view
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            Button {
                                addViewIsPresented.toggle()
                            } label: {
                                Label("Add", systemImage: "plus")
                                    .addButtonStyle()
                            }
                            ForEach(steps) { step in
                                NavigationLink {
                                    StepView(step: step)
                                } label: {
                                    StepCard(step: step)
                                        .onAppear {
                                            displayedSteps = add(step, to: displayedSteps)
                                        }
                                        .onDisappear {
                                            displayedSteps = remove(step, from: displayedSteps)
                                        }
                                }
                                
                                Button {
                                    // TODO: - pass step timestamp to add new step just after
                                    // TODO: - Once location tracking is enabled add suggestions to add step view, based on timestamp and timestamp of next step
                                    addViewIsPresented.toggle()
                                } label: {
                                    Label("Add", systemImage: "plus")
                                        .addButtonStyle()
                                }
                                .offset(x: 30
                                )
                            }
                        }
                    }
//                    .padding()
                    .frame(height: geo.size.height * 0.3)
                }
            }
            
            // MARK: - Navigation
            .navigationTitle($name.onChange(updateTrip))
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
            .onDisappear {
                dataController.save()
            }
        }
    }
    
//    func getCoordinateForLastStep() -> CLLocationCoordinate2D {
////        var region = MKCoordinateRegion()
////        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        if let coordinate = steps.last?.coordinate {
//            region = MKCoordinateRegion(center: center, span: span)
//        }
//        return region
//    }
    
    // MARK: - Update view
    
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
                } else {
                    newArray.insert(step, at: 0)
                }
            }
        }
        return newArray
    }
    
    func updateRegionCoordinates(with steps: [Step]) -> CLLocationCoordinate2D {
            if steps.count > 1 {
                return CLLocationCoordinate2D(
                    latitude: steps[0].latitude,
                    longitude: steps[0].longitude
                )
            } else {
                return CLLocationCoordinate2D(
                    latitude: steps[0].latitude,
                    longitude: steps[0].longitude
                )
        }
    }
    
    // MARK: - Update Model
    
    func updateTrip() {
        // TODO: - Navigating back to tripView does not refresh view
        
        trip.title = name
    }
    
    func deleteSteps(at offsets: IndexSet) {
        
        for offset in offsets {
            let step = steps[offset]
            dataController.delete(step)
        }
        dataController.save()
    }
    
    func delete(_ trip: Trip) {
        for step in trip.tripSteps {
            dataController.delete(step)
        }
        dataController.delete(trip)
        dataController.save()
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: .preview)
    }
}
