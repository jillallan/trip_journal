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
//    @State var region: MKCoordinateRegion
    
    var body: some View {
        let _ = print("Update TripViewMap \(Date.now) \(viewModel.region.center.latitude) \(viewModel.steps.count)")
        let _ = Self._printChanges()
        VStack {
            Text("center: \(viewModel.region.center.latitude)")
            Text("center: \(viewModel.region.center.longitude)")
            
            
            
            MapView(coordinateRegion: $viewModel.region, annotationItems: viewModel.steps) { coord in
                viewModel.setRegion(for: coord)
                print("callback passed: \(viewModel.region.center)")
            }
            
            
            .onAppear {
                print("MapView Will Appear \(viewModel.region)")
            }
        }
        .sheet(isPresented: $addViewIsPresented) {
            AddStepView(viewModel: viewModel, region: viewModel.region)
        }
        .toolbar {
            Button {
                addViewIsPresented.toggle()
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .onAppear {
            print("TripViewMap Will Appear \(viewModel.region)")
            
        }
        .onDisappear {
            print("TripViewMap Will Disappear \(viewModel.region)")
            print("TripViewMap Will Disappear \(viewModel.region)")
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(viewModel: TripViewModel())
    }
}
