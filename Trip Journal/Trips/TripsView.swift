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
    @State var tripAddViewIsPresented: Bool = false
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
                            Spacer()
                            Text("Steps: \(trip.tripSteps.count)")
                        }
                        HStack {
                            Text(trip.tripStartDate, style: .date)
                            Spacer()
                            Text("-")
                            Spacer()
                            Text(trip.tripEndDate, style: .date)
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    tripAddViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $tripAddViewIsPresented) {
                AddTripView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.getUsersDefaultLocale()
            }
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(dataController: .preview, locationManager: LocationManager())
    }
}
