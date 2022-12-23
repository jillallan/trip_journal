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
    @State private var startDate: Date
    @State private var endDate: Date
    
    @State var coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    @State var span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    @State var currentMapRegion: MKCoordinateRegion!
    
    @FetchRequest var steps: FetchedResults<Step>
    @FetchRequest var locations: FetchedResults<Location>
    @State var tripRoute = [MKPolyline]()
    @State var featureAnnotation: MKMapFeatureAnnotation!
    @State var annotationElementId: UUID!
    
    @State var displayedSteps: [Step] = []
    @State var addViewIsPresented: Bool = false
    @State private var locationViewIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var animationAmount = 1.0
    
    // MARK: - Init
    
    init(trip: Trip) {
        self.trip = trip
        _name = State(initialValue: trip.tripTitle)
        _startDate = State(initialValue: trip.tripStartDate)
        _endDate = State(initialValue: trip.tripEndDate)
        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
        
        let startPredicate = NSPredicate(format: "timestamp > %@", trip.tripStartDate as CVarArg)
        let endPredicate = NSPredicate(format: "timestamp < %@", trip.tripEndDate as CVarArg)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [startPredicate, endPredicate])
        
        _locations = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
            predicate: compoundPredicate
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
                            routeOverlay: createRoute(from: locations.map(\.coordinate)), onAnnotationSelection:  { id in
                                annotationElementId = id
//                                locationViewIsPresented = true
                            })
                    }
                    .frame(height: geo.size.height * 0.45)
                    
                    // MARK: - location list view
                    List {
                        ForEach(locations) { location in
                            Text("Lat: \(location.longitude) at: \(location.locationTimestamp)")
                        }
                    }
            
                    // MARK: - Step Scroll view
                    
                    ScrollView(.horizontal) {
                        
                        LazyHGrid(rows: [GridItem()], spacing: 1) {
                            VStack(alignment: .leading) {
                                Text(trip.tripTitle)
                                    .font(.headline.bold())
                                HStack {
                                    DatePicker("Start", selection: $startDate.onChange(updateTrip), displayedComponents: .date)
                                        .labelsHidden()
                                    DatePicker("End", selection: $endDate.onChange(updateTrip), displayedComponents: .date)
                                        .labelsHidden()
                                        .foregroundColor(.white)
                                        .background(Color.gray)
                                }
                            }
                            .photoGridItemStyle(aspectRatio: 1.6, cornerRadius: 0)
                            .background(Color.accentColor)
                            .onAppear {
                                if steps.count < 1 {
                                    if let currentLocation = locationManager.currentLocation?.coordinate {
                                        coordinate = currentLocation
                                    }
                                } else {
                                    coordinate = trip.region.center
                                    span = trip.region.span
                                }
                            }
                            
                            Rectangle().frame(width: 1).hidden()
                            
                            
                            ForEach(steps) { step in
                                ZStack {
                                    NavigationLink { StepView(step: step) } label: { StepCard(step: step) }
                                    
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
            .sheet(isPresented: $locationViewIsPresented) {
                EditLocationView(id: annotationElementId)
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
            .onChange(of: annotationElementId) { _ in
                locationViewIsPresented = true
            }
            .onDisappear {
                dataController.save()
            }
        }
    }
    
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
    
    func updateTrip() {
        // TODO: - Navigating back to tripView does not refresh view
        
        trip.title = name
        trip.startDate = startDate
        trip.endDate = endDate
    }
    
    func delete(_ location: Location) {
        if let step = location.step {
            dataController.delete(step)
        }
        dataController.delete(location)
        dataController.save()
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
