//
//  MapViewUIView.swift
//  Trip Journal
//
//  Created by Jill Allan on 03/11/2022.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var coordinateRegion: MKCoordinateRegion
    let annotationItems: [MKAnnotation]
    var onRegionChange: (CLLocationCoordinate2D) -> ()
    
    func makeUIView(context: Context) -> MKMapView {
        print("will make MKMapView")
        let mapView = MKMapView()
        mapView.addAnnotations(annotationItems)
        mapView.delegate = context.coordinator
        print("did make MKMapView")
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("will update MKMapView")
        uiView.setRegion(coordinateRegion, animated: true)
        uiView.addAnnotations(annotationItems)
        print("did update MKMapView")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    typealias UIViewType = MKMapView

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "step") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Step")
            annotationView.tintColor = UIColor.blue
            annotationView.titleVisibility = .visible
            return annotationView
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.onRegionChange(mapView.centerCoordinate)
        }
    }
}

