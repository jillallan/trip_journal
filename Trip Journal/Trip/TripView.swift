//
//  TripViewMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct TripView: View {
    let trip: Trip
    @StateObject var viewModel: TripViewModel
    @State var addViewIsPresented: Bool = false
    @State var mapTypeConfirmationDialogIsPresented = false
    @State var mapConfiguration: MKMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
    @State var currentCoordinate: CLLocationCoordinate2D!
    
    init(trip: Trip, dataController: DataController, locationManager: LocationManager) {
        self.trip = trip
        let viewModel = TripViewModel(trip: trip, dataController: dataController, locationManager: locationManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                let _ = print("step count \(viewModel.steps.count) - \(viewModel.trip.tripTitle)")
                MapView(
                    coordinateRegion: viewModel.region,
//                    mapViewConfiguration: mapConfiguration,
                    annotationItems: viewModel.steps,
                    routeOverlay: viewModel.tripRoute
                ) { coord in
                    currentCoordinate = coord
                }
                List(viewModel.steps) { step in
                    VStack {
                        Text(step.stepName)
                        Text(step.stepTimestamp, style: .time)
                        Text("Lat: \(step.latitude), Lon: \(step.longitude)")
                            .font(.body)
                    }
                }
                .frame(height: 200)
                .onDisappear {
                    viewModel.setRegion(for: currentCoordinate)
                }
            }
            .sheet(isPresented: $addViewIsPresented) {
                AddStepView(viewModel: viewModel, region: viewModel.region)
            }
            .toolbar {
                Button {
                    viewModel.setRegion(for: currentCoordinate)
                    addViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Choose map", isPresented: $mapTypeConfirmationDialogIsPresented) {
                Button("Standard") {
                    mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
                }
                Button("Hybrid") {
                    mapConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
                }
                Button("Satellite") {
                    mapConfiguration = MKImageryMapConfiguration()
                }
            } message: {
                Text("Choose a map from here")
            }
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController.preview
        let managedObjectContext = dataController.container.viewContext
        let trip = Trip(context: managedObjectContext, title: "France", startDate: Date.now, endDate: Date(timeIntervalSinceNow: 86400))
        
        TripView(
            trip: trip,
            dataController: dataController,
            locationManager: .preview
        )
    }
}

//VStack() {
//    HStack() {
//        Spacer()
//        Button {
//            mapTypeConfirmationDialogIsPresented.toggle()
//        } label: {
//            Label("Map Type", systemImage: "map")
//
//        }
//        .padding()
//        .tint(.gray)
//        .buttonStyle(.borderedProminent)
//        .buttonBorderShape(.roundedRectangle)
//    }
//    Spacer()
//}
