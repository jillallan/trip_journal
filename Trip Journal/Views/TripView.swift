//
//  TripViewMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//


import MapKit
import SwiftUI

struct TripView: View {
    @ObservedObject var viewModel: TripViewModel
    @State var addViewIsPresented: Bool = false
    @State var mapTypeConfirmationDialogIsPresented = false
    @State var mapConfiguration: MKMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
    @State var currentCoordinate: CLLocationCoordinate2D!
    
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

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(viewModel: TripViewModel())
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
