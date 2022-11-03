//
//  MapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var mapViewModel = MapViewModel(
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        Map(
            coordinateRegion: $mapViewModel.region,
            annotationItems: mapViewModel.steps,
            annotationContent: { step in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: step.latitude, longitude: step.longitude))
            }
        )
            .navigationTitle("Map View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    mapViewModel.addStep()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
