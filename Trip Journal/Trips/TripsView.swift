//
//  TripsView.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import MapKit
import SwiftUI

struct TripsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    @FetchRequest(
        entity: Trip.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)]
    ) var trips: FetchedResults<Trip>

    @State var addTripViewIsPresented: Bool = false
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 31), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $mapRegion)
                .frame(height: 200)
            List {
                ForEach(trips) { trip in
                    NavigationLink {
                        TripView(trip: trip)
                    } label: {
                        TripCardView(trip: trip)
                    }
                }
                .onDelete { indexSet in
                    deleteTrips(at: indexSet)
                }
            }
            
            .toolbar {
                Button {
                    addTripViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $addTripViewIsPresented) {
            } content: {
                AddTripView()
            }
        }
    }
    
    // MARK: - Update model
    
    func deleteTrips(at offsets: IndexSet) {
        // TODO: - Do we need sort order
        
        for offset in offsets {
            
            let trip = trips[offset]
            let steps = trip.tripSteps
            for step in steps {
                dataController.delete(step)
            }
            dataController.delete(trip)
        }
        dataController.save()
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(DataController.preview)
            .environmentObject(LocationManager.preview)
    }
}
