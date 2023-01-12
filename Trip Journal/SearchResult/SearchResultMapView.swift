//
//  SearchResultMapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import MapKit
import SwiftUI

struct SearchResultMapView: View {
    let result: MKMapItem
    @State var centre: CLLocationCoordinate2D
    @State var span: MKCoordinateSpan
//    @State var region: MKCoordinateRegion
    @State var annotation: MKAnnotation? = nil

//    let annotationItems: [AnnotationItem]
    
    init(result: MKMapItem) {
        self.result = result
//        let centre = result.placemark.coordinate
        _centre = State(initialValue: result.placemark.coordinate)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        _span = State(initialValue: span)
//        let region = MKCoordinateRegion(center: result.placemark.coordinate, span: span)
//        _region = State(initialValue: region)
//        let annotationItem = AnnotationItem(
//            title: result.placemark.title ?? "No title", // Update to better placeholder
//            latitude: result.placemark.coordinate.latitude,
//            longitude: result.placemark.coordinate.longitude
//        )
        
//        viewModel = SearchResultMapViewModel(result: result, region: region, annotationItems: [annotationItem])
    }
    
    var body: some View {
        VStack {
            MapView2(
                centre: $centre,
                span: $span,
                annotationsDidChange: false,
                routeOverlay: nil,
                selectedAnnotation: $annotation
            )
            
//            MapView(
//                coordinateRegion: region,
//                annotationItems: nil,
//                annotationsDidChange: false,
//                routeOverlay: nil
//            )
            // TODO: - Add better name coalesing
//            Text("\(result.name ?? "No name")")
      
//                .padding()
        }
    }
}

//struct SearchResultMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultMapView(searchResult: MKMapItem(placemark: MKPlacemark(coordinate: Entry.preview.coordinate)))
//    }
//}
