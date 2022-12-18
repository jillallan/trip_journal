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
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(trips) { trip in
                        NavigationLink {
                            TripView(trip: trip)
                        } label: {
                            TripCard(trip: trip)
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                Button {
                    addTripViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            
            // MARK: - Navigation
            
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $addTripViewIsPresented) {
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
