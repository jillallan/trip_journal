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
    var onAnnotationSelection: ((MKMapFeatureAnnotation) -> ())?
    
    // MARK: - Protocol Methods
    
    func makeUIView(context: Context) -> MKMapView {

        print("will make view: \(coordinateRegion.center)")
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
        
        print("did make view: \(coordinateRegion.center)")
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("will update view: \(coordinateRegion.center)")
        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.preferredConfiguration = mapViewConfiguration
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
        
        if let routeOverlay = routeOverlay {
            mapView.addOverlays(routeOverlay)
        }
        print("did update view: \(coordinateRegion.center)")
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
            guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
            
            if let onAnnotationSelection = parent.onAnnotationSelection {
                print("mapview: \(featureAnnotation.coordinate)")
                onAnnotationSelection(featureAnnotation)
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

