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
    
    @FetchRequest(
        entity: Trip.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)]
    ) var trips: FetchedResults<Trip>

    @State var addTripViewIsPresented: Bool = false
    @State var navPath: [Trip] = []
    
    // MARK: - View
    
    var body: some View {
        let _ = print(navPath)
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(trips) { trip in
                        NavigationLink(value: trip) {
                            Text("row \(trip.tripTitle)")
                        }
                    }
                }
            }
            .navigationDestination(for: Trip.self) { trip in
//                Text("detail \(trip.tripTitle)")
                TripView(trip: trip)
            }
        }
    }
    
//    var body: some View {
//        NavigationStack {
//            ScrollView() {
//                LazyVGrid(columns: [GridItem(.flexible())]) {
//                    ForEach(trips) { trip in
//
//                        NavigationLink { TripView(trip: trip) } label: {
//                            TripCard(trip: trip)
//                        }
//                    }
//                }
//            }
//            .padding()
//            .toolbar {
//                Button {
//                    addTripViewIsPresented.toggle()
//                } label: {
//                    Label("Add", systemImage: "plus")
//                }
//            }
//            .navigationTitle("Trips")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationDestination(for: Trip.self) { trip in
//                TripView(trip: trip)
//            }
//            .sheet(isPresented: $addTripViewIsPresented) {
//            } content: {
//                AddTripView()
//            }
//        }
//    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(DataController.preview)
            .environmentObject(LocationManager.preview)
    }
}
