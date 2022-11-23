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
//    let mapViewConfiguration: MKMapConfiguration
    let annotationItems: [MKAnnotation]?
    let routeOverlay: [MKPolyline]?
    var onRegionChange: ((MKCoordinateRegion) -> ())?
    
    func makeUIView(context: Context) -> MKMapView {

        let mapView = MKMapView()
        mapView.region = coordinateRegion
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
//        mapView.preferredConfiguration = mapViewConfiguration
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
//        let mapFeatureOptions = MKMapFeatureOptions()
//        MKMapFeatureOptions.pointsOfInterest =
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.preferredConfiguration = mapViewConfiguration
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
            let featureIdentifier = "feature"
            if let featureAnnotation = annotation as? MKMapFeatureAnnotation? {
                let featureAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: featureIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: featureAnnotation, reuseIdentifier: featureIdentifier)
                
                featureAnnotationView.markerTintColor = featureAnnotation?.iconStyle?.backgroundColor
                featureAnnotationView.selectedGlyphImage = featureAnnotation?.iconStyle?.image
                featureAnnotationView.glyphImage = featureAnnotation?.iconStyle?.image
                
                return featureAnnotationView
            }
            
            let stepIdentifier = "Step"
            let stepAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: stepIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: stepIdentifier)
            stepAnnotationView.markerTintColor = UIColor.systemIndigo
            stepAnnotationView.titleVisibility = .hidden
            stepAnnotationView.glyphImage = UIImage(systemName: "figure.walk")
            return stepAnnotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.systemIndigo
            renderer.lineWidth = 3.0
            return renderer
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if let onRegionChange = parent.onRegionChange {
                onRegionChange(mapView.region)
            }
        }
    }
}

