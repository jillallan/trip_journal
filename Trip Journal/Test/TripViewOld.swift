//
//  TripViewTest.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/11/2022.
//
import MapKit
import SwiftUI

struct TripViewOld: View {
    @StateObject var viewModel: TripViewModelOld
    @State var region: MKCoordinateRegion
    @State var addViewIsPresented: Bool = false
    
    
    init(persistanceController: PersistanceController) {
        let viewModel = TripViewModelOld(persistanceController: persistanceController)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.region = viewModel.region
        _addViewIsPresented = State(wrappedValue: false)
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.steps) { step in
                MapMarker(coordinate: step.coordinate)
            }
            .navigationTitle("Map View")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            
            
            List {

                ForEach(viewModel.steps) { step in

                    VStack(alignment: .leading) {
                        Text(step.name)
                            .font(.headline)
                        Text("Lat: \(step.latitude) Lon: \(step.longitude)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .sheet(isPresented: $addViewIsPresented) {
            AddStepViewOld(viewModel: viewModel, region: region)
        }
        .toolbar {
            Button {
                addViewIsPresented.toggle()
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
//        .onAppear(perform: viewModel.setRegion)
    }
}

struct TripViewOld_Previews: PreviewProvider {
    static var previews: some View {
        TripViewOld(persistanceController: PersistanceController())
    }
}
