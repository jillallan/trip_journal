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
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    
    // MARK: - Trip Properties
    let trip: Trip
    @FetchRequest var steps: FetchedResults<Step>
    @FetchRequest var locations: FetchedResults<Location>
    
    // MARK: - View Properties
    @State var centre = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    @State var span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @State var addViewIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State var displayedSteps: [Step] = []
    @State private var currentStep: Step? = nil
    @State private var currentLocation: Location? = nil
    
    
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
        GeometryReader { geo in
            VStack {
                let _ = print("fetchrequest count: \(locations.count)")
                let _ = Self._printChanges()
                
                // MARK: - Map View
                TripMap(coordinate: $centre, span: $span, locations: locations, trip: trip, geo: geo)
                
                // MARK: - Step Scroll view
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem()], spacing: 1) {
                        TripTitleCard(trip: trip)
                            .onAppear {
                                centre = getMapCentre(locations: locations, locationManager: locationManager)
                                span = getMapSpan(locations: locations, locationManager: locationManager)
                            }
                        Rectangle().frame(width: 1).hidden()
                        
                        ForEach(steps) { step in
                            ZStack {
                                NavigationLink(value: step) {
                                    StepCard(step: step)
                                }
                                
                                // TODO: - Add suggestions between two steps
                                Button { currentStep = setCurrentStep(step: step, steps: steps) } label: {
                                    Label("Add", systemImage: "plus").addButtonStyle()
                                }
                                .offset(x: -(((geo.size.height * 0.3 * 1.6) + 3) / 2))
                            }
                            Rectangle().frame(width: 1).hidden()
                                .onAppear {
                                    displayedSteps = add(step, to: displayedSteps)
                                }
                        }
                        
                        Button {
                            if let step = steps.last {
                                currentStep = step
                            } else {
                                addViewIsPresented.toggle()
                            }
                        } label: {
                            Label("Add", systemImage: "plus").addButtonStyle()
                        }
                        .offset(x: -17)
                    }
                }
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
            // TODO: - center on new step ondismiss of AddStepView if new step added
            AddStepView(coordinate: centre, trip: trip, date: Date.now)
        }
        
        .sheet(item: $currentStep) { step in
            // TODO: - center on new step ondismiss of AddStepView if new step added
            AddStepView(coordinate: step.coordinate, trip: trip, date: step.stepTimestamp)
        }
        .onChange(of: displayedSteps) { newStepsArray in
            if !newStepsArray.isEmpty {
                centre = updateRegionCoordinates(with: newStepsArray)
            }
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let currentCentre = newLocation?.coordinate {
                centre = currentCentre
            }
        }
        .navigationDestination(for: Step.self) { step in
            StepView(step: step)
        }
        
        
    }
    
    // MARK: - Update view
    
    func getMapCentre(locations: FetchedResults<Location>, locationManager: LocationManager) ->  CLLocationCoordinate2D {
        if !locations.isEmpty {
            return calculateTripRegion(from: locations).center
        }
        if let currentCentre = locationManager.currentLocation?.coordinate {
            return currentCentre
        }
        return CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    }
    
    func getMapSpan(locations: FetchedResults<Location>, locationManager: LocationManager) ->  MKCoordinateSpan {
        if !locations.isEmpty {
            return calculateTripRegion(from: locations).span
        }
        return MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    }
    
    func calculateTripRegion(from locations: FetchedResults<Location>) -> MKCoordinateRegion {
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
    
    func setCurrentStep(step: Step, steps: FetchedResults<Step>) -> Step {
        if let stepIndex = steps.firstIndex(of: step) {
            if stepIndex != 0 {
                return steps[stepIndex - 1]
            }
        }
        return step
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
                dataController.delete(location)
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

