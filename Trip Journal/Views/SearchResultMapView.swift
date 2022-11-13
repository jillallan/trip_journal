//
//  SearchResultMapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import MapKit
import SwiftUI

struct SearchResultMapView: View {
    @State var searchResultRegion: MKCoordinateRegion
    @State var annotationItems: [AnnotationItem]
    
    init(result: MKMapItem) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: result.placemark.coordinate, span: span)
        _searchResultRegion = State(wrappedValue: region)
        
        let annotationItem = AnnotationItem(
            title: result.placemark.title ?? "No title", // Update to better placeholder
            latitude: result.placemark.coordinate.latitude,
            longitude: result.placemark.coordinate.longitude
        )
        _annotationItems = State(wrappedValue: [annotationItem])
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $searchResultRegion, annotationItems: annotationItems) { item in
                MapMarker(coordinate: item.coordinate)
            }
        }
    }
}

struct SearchResultMapView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultMapView(result: MKMapItem(placemark: MKPlacemark(coordinate: Step.preview.coordinate)))
    }
}
