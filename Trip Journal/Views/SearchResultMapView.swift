//
//  SearchResultMapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import MapKit
import SwiftUI

struct SearchResultMapView: View {
    @State var searchResult: MKMapItem
    @State var searchResultRegion: MKCoordinateRegion
    @State var annotationItems: [AnnotationItem]
    let regionNew: MKCoordinateRegion
    
    init(searchResult: MKMapItem) {
        self.searchResult = searchResult
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: searchResult.placemark.coordinate, span: span)
        _searchResultRegion = State(wrappedValue: region)
        regionNew = region
        
        let annotationItem = AnnotationItem(
            title: searchResult.placemark.title ?? "No title", // Update to better placeholder
            latitude: searchResult.placemark.coordinate.latitude,
            longitude: searchResult.placemark.coordinate.longitude
        )
        _annotationItems = State(wrappedValue: [annotationItem])
    }
    
    var body: some View {
        VStack {
//            Map(coordinateRegion: $searchResultRegion, annotationItems: annotationItems) { item in
//                MapMarker(coordinate: item.coordinate)
//            }
            MapView(
                coordinateRegion: regionNew,
                mapViewConfiguration: MKStandardMapConfiguration(
                    elevationStyle: .realistic,
                    emphasisStyle: .muted
                ),
                annotationItems: nil,
                onRegionChange: nil
            )
            Text("\(searchResult)")
                .padding()
        }
    }
}

struct SearchResultMapView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultMapView(searchResult: MKMapItem(placemark: MKPlacemark(coordinate: Step.preview.coordinate)))
    }
}
