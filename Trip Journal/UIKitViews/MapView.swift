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
    
    // MARK: - Properties
    
    var coordinateRegion: MKCoordinateRegion
    let annotationItems: [MKAnnotation]?
    let routeOverlay: [MKPolyline]?
    var onRegionChange: ((MKCoordinateRegion) -> ())?
    var onFeatureAnnotationSelection: ((MKAnnotation) -> ())?
    var onAnnotationSelection: ((UUID) -> ())?
    
    // MARK: - Protocol Methods
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
        let pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.university])
        
        mapView.region = coordinateRegion
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        mapView.preferredConfiguration = mapConfiguration
        
        mapConfiguration.pointOfInterestFilter = pointOfInterestFilter
        
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }

        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
//        mapView.preferredConfiguration = mapViewConfiguration
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
        
        if let routeOverlay = routeOverlay {
            if !mapView.overlays.isEmpty {
                mapView.removeOverlays(mapView.overlays)
                
            }
            mapView.addOverlays(routeOverlay)
        }
//        if !mapView.selectedAnnotations.isEmpty {
//            let selectedAnnotation = mapView.selectedAnnotations[0]
//            mapView.deselectAnnotation(selectedAnnotation, animated: true)
//        }
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
        
        // MARK: - Delegate Methods
        
        // MARK: - Annotations
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            }
            
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
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            
            if let featureAnnotation = annotation as? MKMapFeatureAnnotation {
                if let onFeatureAnnotationSelection = parent.onFeatureAnnotationSelection {
                    onFeatureAnnotationSelection(featureAnnotation)
                }
            }

//            let id = annotation.annotationElementId
            if let onAnnotationSelection = parent.onAnnotationSelection {
                onAnnotationSelection(annotation.annotationElementId)
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // https://holyswift.app/how-to-removesuppress-the-default-mapkit-user-location-callout-annotation/
            if view.annotation is MKUserLocation {
                mapView.deselectAnnotation(view.annotation, animated: false)
                return
            }
        }
        
        
        // MARK: - Overlays
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.systemIndigo
            renderer.lineWidth = 3.0
            return renderer
        }
        
        // MARK: - Region
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if let onRegionChange = parent.onRegionChange {
                onRegionChange(mapView.region)
            }
        }
    }
}

