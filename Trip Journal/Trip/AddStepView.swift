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
    @State var stepAdded: Bool = false
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
                                    stepAdded.toggle()
                                    dismiss()
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
        .onDisappear {
            if stepAdded {
                viewModel.addStep(for: region.center)
                viewModel.setRegion(for: region.center)
            }
        }
    }
}

//struct AddStepView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = TripViewModel(persistanceController: .preview)
//        AddStepView(viewModel: viewModel, region: viewModel.region)
//    }
//}
