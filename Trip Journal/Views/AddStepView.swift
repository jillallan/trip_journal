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
    @Environment(\.dismiss) var dismiss
    @State var isPresented: Bool = false
    @Environment(\.dismissSearch) private var dismissSearch
    
    init(viewModel: TripViewModel, region: MKCoordinateRegion) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _region = State(wrappedValue: region)
        _locationQuery = StateObject(wrappedValue: LocationQuery(region: region))
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(region.center.latitude)")
                ZStack {
                    
                    Map(coordinateRegion: $region)
                        .toolbar(.visible, for: .navigationBar)
                        .navigationTitle("Add Step")
                        .navigationBarTitleDisplayMode(.inline)
                        .ignoresSafeArea(edges: .bottom)
                        .toolbar {
                            Button {
                                dismiss()
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                        }
                        .searchable(text: $locationQuery.searchQuery) {
                            ForEach(locationQuery.searchResults, id: \.self) { result in
                                Button {
                                    isPresented.toggle()
                                    
                                    region.center = result.placemark.coordinate
                                } label: {
                                    VStack {
                                        Text(result.name ?? "N/A")
                                        Text(result.placemark.subLocality ?? "N/A")
                                    }
                                }
                                .sheet(isPresented: $isPresented) {
                                    NavigationStack {
                                        Text("\(result)")
                                            .toolbar {
                                                Button("Add") {
                                                    // Store the item here...
                                                    viewModel.region.center = result.placemark.coordinate
                                                    dismiss()
                                                    dismissSearch()
                                                }
                                            }
                                            .onDisappear {
                                                dismissSearch()
                                            }
                                    }
                                }
                                
//

    //                            Text(result)
    //                                .searchCompletion(result)
                            }
                            .onDisappear {
                                print("dismissed search list")
                            }
                        }
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .onDisappear {
            viewModel.addStep(for: region.center)
            viewModel.setRegion(for: region.center)
        }
    }
}

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TripViewModel()
        AddStepView(viewModel: viewModel, region: viewModel.region)
    }
}
