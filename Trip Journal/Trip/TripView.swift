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
    @FetchRequest var entries: FetchedResults<Entry>
    @FetchRequest var steps: FetchedResults<Step>
    
    // MARK: - View Properties
    @State var centre = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    @State var span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @State var addViewIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    
//    @State var displayedEntries: [Entry] = []
    @State private var currentEntry: Entry? = nil
    @State private var currentLocation: Step? = nil
    
    
    // MARK: - Init
    
    init(trip: Trip) {
        self.trip = trip
        
        let tripStartPredicate = NSPredicate(format: "timestamp > %@", trip.tripStartDate as CVarArg)
        let tripEndPredicate = NSPredicate(format: "timestamp < %@", trip.tripEndDate as CVarArg)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [tripStartPredicate, tripEndPredicate])
        
        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: compoundPredicate
        )
        _entries = FetchRequest<Entry>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Entry.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                // MARK: - Map View
                TripMap(coordinate: $centre, span: $span, steps: steps, trip: trip, geo: geo)
                
                // MARK: - Entry Scroll view
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem()], spacing: 3) {
                        TripTitleCard(trip: trip)
                            .onAppear {
                                centre = getMapCentre(steps: steps, locationManager: locationManager)
                                span = getMapSpan(steps: steps, locationManager: locationManager)
                            }
                        ForEach(entries) { entry in
                            ZStack {
                                NavigationLink(value: entry) {
                                    EntryCard(entry: entry)
                                        .onAppear {
                                            print("Entry appeared: \(entry)")
                                            centre = updateRegionCoordinates(with: entry)
                                        }
                                }
                                
                                // TODO: - Add suggestions between two entries
                                Button { currentEntry = setCurrentEntry(entry: entry, entries: entries) } label: {
                                    Label("Add", systemImage: "plus").addButtonStyle()
                                }
                                .offset(x: -(((geo.size.height * 0.3 * 1.6) + 3) / 2))
                            }
                        }
                        
                        Button {
                            if let entry = entries.last {
                                currentEntry = entry
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
        .navigationDestination(for: Entry.self) { entry in
            EntryView(entry: entry)
        }
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
            // TODO: - center on new entry ondismiss of AddEntryView if new entry added
            AddEntryView(coordinate: centre, trip: trip, date: Date.now)
        }
        
        .sheet(item: $currentEntry) { entry in
            // TODO: - center on new entry ondismiss of AddEntryView if new entry added
            AddEntryView(coordinate: entry.coordinate, trip: trip, date: entry.entryTimestamp)
        }

        // MARK: - Update View
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let currentCentre = newLocation?.coordinate {
                centre = currentCentre
            }
        }
        
    }
    
    // MARK: - Update view
    
    func getMapCentre(steps: FetchedResults<Step>, locationManager: LocationManager) ->  CLLocationCoordinate2D {
        if !steps.isEmpty {
            return calculateTripRegion(from: steps).center
        }
        if let currentCentre = locationManager.currentLocation?.coordinate {
            return currentCentre
        }
        return CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
    }
    
    func getMapSpan(steps: FetchedResults<Step>, locationManager: LocationManager) ->  MKCoordinateSpan {
        if !steps.isEmpty {
            return calculateTripRegion(from: steps).span
        }
        return MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    }
    
    func calculateTripRegion(from steps: FetchedResults<Step>) -> MKCoordinateRegion {
        let minLatitude = steps.map(\.coordinate.latitude).min() ?? 0.0
        let maxLatitude = steps.map(\.coordinate.latitude).max() ?? 0.0
        let minLongitude = steps.map(\.coordinate.longitude).min() ?? 0.0
        let maxLongitude = steps.map(\.coordinate.longitude).max() ?? 0.0
        
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
    
    func setCurrentEntry(entry: Entry, entries: FetchedResults<Entry>) -> Entry {
        if let entryIndex = entries.firstIndex(of: entry) {
            if entryIndex != 0 {
                return entries[entryIndex - 1]
            }
        }
        return entry
    }
    
    func updateRegionCoordinates(with entry: Entry) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: entry.latitude,
            longitude: entry.longitude
        )
    }
    
    // MARK: - Update Model
    
    func delete(_ trip: Trip) {
        for entry in trip.tripEntries {
            delete(entry)
        }
        dataController.delete(trip)
        dataController.save()
    }
    
    func delete(_ entry: Entry) {
        if let step = entry.step {
            if step.distance == 0 && step.horizontalAccuracy == 0 {
                dataController.delete(step)
            }
            dataController.delete(entry)
        }
        dataController.save()
    }
}

//struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip: .preview)
//    }
//}

