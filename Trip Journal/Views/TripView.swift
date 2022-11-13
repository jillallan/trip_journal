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
    @State var passedBackCoord: CLLocationCoordinate2D!
    
    var body: some View {
        VStack {
            MapView(coordinateRegion: viewModel.region, annotationItems: viewModel.steps) { coord in
                passedBackCoord = coord
            }
            .onDisappear {
                viewModel.setRegion(for: passedBackCoord)
            }
        }
        .sheet(isPresented: $addViewIsPresented) {
            AddStepView(viewModel: viewModel, region: viewModel.region)
        }
        .toolbar {
            Button {
                viewModel.setRegion(for: passedBackCoord)
                addViewIsPresented.toggle()
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(viewModel: TripViewModel())
    }
}
