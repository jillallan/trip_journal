//
//  TripViewMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct TripView: View {
    @StateObject var viewModel: TripViewModel
    @State var addViewIsPresented: Bool = false
    @State var mapTypeConfirmationDialogIsPresented = false
    @State var mapConfiguration: MKMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
    @State var currentCoordinate: CLLocationCoordinate2D!
    
    init(dataController: DataController) {
        let viewModel = TripViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                MapView(
                    coordinateRegion: viewModel.region,
                    mapViewConfiguration: mapConfiguration,
                    annotationItems: viewModel.steps,
                    routeOverlay: viewModel.tripRoute
                ) { coord in
                    currentCoordinate = coord
                }
                List(viewModel.steps) { step in
                    VStack {
                        Text(step.timestamp ?? Date.now, style: .time)
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
//            .ignoresSafeArea(edges: .bottom)
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

//struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(viewModel: TripViewModel(dataController: .preview))
//    }
//}

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
