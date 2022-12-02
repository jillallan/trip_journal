//
//  TripViewMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct TripView: View {
    
    // MARK: - Properties
    
    let trip: Trip
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var viewModel: TripViewModel
    @State var addViewIsPresented: Bool = false
    @State var mapTypeConfirmationDialogIsPresented = false
    @State var mapConfiguration: MKMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
    @State var currentMapRegion: MKCoordinateRegion!
    
    // MARK: - Init
    
    init(trip: Trip, dataController: DataController, locationManager: LocationManager) {
        self.trip = trip
        let viewModel = TripViewModel(trip: trip, dataController: dataController, locationManager: locationManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack {
                MapView(
                    coordinateRegion: viewModel.region,
                    annotationItems: viewModel.steps,
                    routeOverlay: viewModel.tripRoute
                ) { region in
                    currentMapRegion = region
                }
                List {
                    ForEach(viewModel.steps) { step in
                        NavigationLink {
                            StepView(step: step)
                        } label: {
                            StepViewCell(step: step)
                        }
                    }
                    .onDelete { indexSet in
                        print(indexSet.description)
                        viewModel.deleteSteps(at: indexSet)
                        viewModel.steps = viewModel.fetchSteps()
                    }
                }
                .frame(height: 300)
                
                .onDisappear {
                    viewModel.region = currentMapRegion
                }
            }
            .sheet(isPresented: $addViewIsPresented) {
                // On dismiss of addView
                viewModel.steps = viewModel.fetchSteps()
                viewModel.region = viewModel.getRegionForLastStep()
            } content: {
                AddStepView(coordinate: viewModel.region.center, trip: trip, dataController: dataController)
            }
            .toolbar {
                Button {
                    viewModel.region = currentMapRegion
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
            .onAppear {
                print("TripView did appear")
                print("step timestamp\(String(describing: viewModel.steps[2].timestamp))")
                viewModel.steps = viewModel.fetchSteps()
                print("step timestamp\(String(describing: viewModel.steps[2].timestamp))")
            }
        }
    }
}

// MARK: - Xcode Preview

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(
            trip: .preview,
            dataController: .preview,
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
