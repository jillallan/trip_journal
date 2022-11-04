//
//  MapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import MapKit
import SwiftUI

struct TripView: View {
    @StateObject var mapViewModel = MapViewModel()
    @State private var addStepViewPresented = false
    var body: some View {
        
        Map(
            coordinateRegion: $mapViewModel.region,
            annotationItems: mapViewModel.steps,
            annotationContent: { step in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: step.latitude, longitude: step.longitude))
            }
        )
//        MapViewUIView(
//            coordinateRegion: $mapViewModel.region,
//            viewModel: mapViewModel,
//            annotationItems: mapViewModel.steps
//        )
        .sheet(isPresented: $addStepViewPresented, content: {
            AddStepView(viewModel: mapViewModel)
        })
        
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                addStepViewPresented.toggle()
                //                    mapViewModel.addStep()
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView()
    }
}
