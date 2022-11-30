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
    @StateObject var viewModel: TripsViewModel
    @State var addTripViewIsPresented: Bool = false
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 31), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    init(dataController: DataController, locationManager: LocationManager) {
        let viewModel = TripsViewModel(dataController: dataController, locationManager: locationManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $mapRegion)
                .frame(height: 200)
            List(viewModel.trips) { trip in
                NavigationLink {
                    TripView(trip: trip, dataController: dataController, locationManager: locationManager)
                } label: {
                    VStack {
                        HStack {
                            Text(trip.tripTitle)
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            Spacer()
                            Text("\(trip.tripSteps.count) steps")
                                .foregroundColor(.accentColor)
                        }
                        HStack {
                            Text(trip.tripStartDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("-")
                            Spacer()
                            Text(trip.tripEndDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    addTripViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $addTripViewIsPresented) {
                viewModel.trips = viewModel.fetchTrips()
            } content: {
                AddTripView(dataController: dataController, locationManager: locationManager)
            }
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(dataController: .preview, locationManager: .preview)
            .environmentObject(DataController.preview)
            .environmentObject(LocationManager.preview)
    }
}
