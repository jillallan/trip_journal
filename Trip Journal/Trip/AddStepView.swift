//
//  TripViewMapAddStep.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct AddStepView: View {
    @ObservedObject var viewModel: TripViewModel
    @StateObject private var locationQuery: LocationQuery
    @State var region: MKCoordinateRegion
    @State private var stepAdded: Bool = false
    @State private var isAddStepPlacemarksViewPresented: Bool = false
    @State var placemarkName = ""
    @State var currentMapRegion: MKCoordinateRegion!
    @Environment(\.dismiss) var dismiss


    
    init(viewModel: TripViewModel, region: MKCoordinateRegion) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _region = State(wrappedValue: region)
        _locationQuery = StateObject(wrappedValue: LocationQuery(region: region))
    }
    
    var body: some View {
//        let _ = print("add step view top")
//        let _ = Self._printChanges()
        NavigationStack {
//            let _ = print("add step view: \(String(describing: currentCoordinate))")
            VStack {
                ZStack {
//                    Map(coordinateRegion: $region)
                    AddStepMapView(coordinateRegion: region) { region in
                        currentMapRegion = region
                        print("closure: \(String(describing: currentMapRegion))")
                    }
                        .toolbar(.visible, for: .navigationBar)
                        .navigationTitle("Add Step")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea(edges: .bottom)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    print("button pressed")
                                    print("button: \(String(describing: currentMapRegion))")
                                    viewModel.setRegion(with: currentMapRegion)
                                    isAddStepPlacemarksViewPresented.toggle()
//                                    stepAdded.toggle()
//                                    dismiss()
                                } label: {
                                    Label("Add", systemImage: "plus")
                                }
                            }
                                
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel", role: .cancel) {
                                    dismiss()
                                }
                            }
                        }
                        
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                }
                .searchable(text: $locationQuery.searchQuery) {
                    SearchResultsView(viewModel: viewModel, locationQuery: locationQuery)
                        .frame(height: 500)
                }
            }
        }
        .sheet(isPresented: $isAddStepPlacemarksViewPresented) {
            AddStepPlacemarksView(
                viewModel: viewModel,
                placemarkName: $placemarkName,
                coordinates: viewModel.region.center
            )
                .presentationDetents([.medium, .large])
        }
        .onDisappear {
            print("dissapper")
            if stepAdded {
                viewModel.addStep(for: currentMapRegion.center, name: placemarkName)
                viewModel.setRegion(with: currentMapRegion)
            }
        }
        .onChange(of: placemarkName) { newValue in
            stepAdded = true
            dismiss()
            // TODO: - Does dismiss and add of step need refactoring
        }
    }
}

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepView(
            viewModel: .preview,
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        )
    }
}
