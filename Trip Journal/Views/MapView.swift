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
    let mapViewConfiguration: MKMapConfiguration
    let annotationItems: [MKAnnotation]?
    let routeOverlay: [MKPolyline]?
    var onRegionChange: ((CLLocationCoordinate2D) -> ())?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
        mapView.preferredConfiguration = mapViewConfiguration
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.preferredConfiguration = mapViewConfiguration
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
        
        if let routeOverlay = routeOverlay {
            mapView.addOverlays(routeOverlay)
        }
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
            let identifier = "Step"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.markerTintColor = UIColor.systemIndigo
            annotationView.titleVisibility = .hidden
            annotationView.glyphImage = UIImage(systemName: "figure.walk")
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.systemIndigo
            renderer.lineWidth = 3.0
            return renderer
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if let onRegionChange = parent.onRegionChange {
                onRegionChange(mapView.centerCoordinate)
            }
//            parent.onRegionChange(mapView.centerCoordinate)
        }
    }
}

