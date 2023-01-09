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

    @State var isAddTripViewPresented: Bool = false
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(trips) { trip in
                        
                        NavigationLink(value: trip) {
                            TripCard(trip: trip)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                Button {
                    isAddTripViewPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Trip.self) { trip in
                TripView(trip: trip)
            }
            .sheet(isPresented: $isAddTripViewPresented) {
            } content: {
                AddTripView()
            }
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(DataController.preview)
            .environmentObject(LocationManager.preview)
    }
}
