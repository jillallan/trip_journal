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
//    @State private var placemarkAddress = ""
    @Environment(\.dismiss) var dismiss
//    @State var isPresented: Bool = false
//    @Environment(\.dismissSearch) private var dismissSearch
    
    init(viewModel: TripViewModel, region: MKCoordinateRegion) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _region = State(wrappedValue: region)
        _locationQuery = StateObject(wrappedValue: LocationQuery(region: region))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(coordinateRegion: $region)
                        .toolbar(.visible, for: .navigationBar)
                        .navigationTitle("Add Step")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea(edges: .bottom)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
//                                    viewModel.fetchPlacemarks(for: region.center)
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
                coordinates: region.center
            )
                .presentationDetents([.medium, .large])
        }
        .onDisappear {
            if stepAdded {
                viewModel.addStep(for: region.center, name: placemarkName)
                viewModel.setRegion(for: region.center)
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
