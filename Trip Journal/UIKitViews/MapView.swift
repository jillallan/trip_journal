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
    var onAnnotationSelection: ((MKAnnotation) -> ())?
//    var onAnnotationSelection: ((UUID) -> ())?
    
    // MARK: - Protocol Methods
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
        let pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.university])
        
        mapView.region = coordinateRegion
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        mapView.preferredConfiguration = mapConfiguration
        
        mapConfiguration.pointOfInterestFilter = pointOfInterestFilter
        
//        if let annotationItems = annotationItems {
//            mapView.addAnnotations(annotationItems)
//        }
        
        
        if let routeOverlay = routeOverlay {
            if !mapView.overlays.isEmpty {
                mapView.removeOverlays(mapView.overlays)
                
            }
            mapView.addOverlays(routeOverlay)
        }
        
        if let annotationItems = annotationItems {
            print("annotation items: \(annotationItems.count)")
//            print(annotationItems[0])
//            print(annotationItems[28])
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            mapView.addAnnotations(annotationItems)
        }

        mapView.delegate = context.coordinator
        print("annotation items: \(String(describing: annotationItems?.count))")
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
        
        if let annotationItems = annotationItems {
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            mapView.addAnnotations(annotationItems)
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
        
        // MARK: - Delegate Methods
        
        // MARK: - Annotations
        
        @MainActor func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
            if let stepAnnotation = annotation as? Step {
                let stepAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: stepIdentifier) ?? MKAnnotationView(annotation: stepAnnotation, reuseIdentifier: stepIdentifier)
                
                if let photoAnnotation = renderAnnotationStep() {
                    stepAnnotationView.image = photoAnnotation
                    return stepAnnotationView
                }
            }
            
            let locationIdentifier = "location"
            if let locationAnnotation = annotation as? Location {
                let locationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: locationIdentifier) ?? MKAnnotationView(annotation: locationAnnotation, reuseIdentifier: locationIdentifier)
                
                if locationAnnotation.step != nil {
                    return nil
                } else {
                    if let circleAnnotation = renderAnnotationCircle() {
                        locationAnnotationView.image = circleAnnotation
                        return locationAnnotationView
                    }
                }
            }
            
      
            
            
//            let stepAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: stepIdentifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: stepIdentifier)
//            stepAnnotationView.markerTintColor = UIColor.systemIndigo
//            stepAnnotationView.titleVisibility = .hidden
//            stepAnnotationView.glyphImage = UIImage(systemName: "figure.walk")
            
//            return stepAnnotationView
            return nil
        }
        
        @MainActor func renderAnnotationCircle() -> UIImage? {
            let renderer = ImageRenderer(content: CircleAnnotation())
            // TODO: Pass displayScale environment variable in from swiftui view
            // https://developer.apple.com/documentation/swiftui/environmentvalues/displayscale/
            renderer.scale = 3.0
            
            guard let uiImage = renderer.uiImage else { return nil }
            return uiImage
         
        }
        
        @MainActor func renderAnnotationStep() -> UIImage? {
            let renderer = ImageRenderer(content: StepAnnotation())
            // TODO: Pass displayScale environment variable in from swiftui view
            // https://developer.apple.com/documentation/swiftui/environmentvalues/displayscale/
            renderer.scale = 3.0
            
            guard let uiImage = renderer.uiImage else { return nil }
            return uiImage
         
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            
            if let featureAnnotation = annotation as? MKMapFeatureAnnotation {
                if let onAnnotationSelection = parent.onAnnotationSelection {
                    onAnnotationSelection(featureAnnotation)
                }
            }
            
            if let locationAnnotation = annotation as? Location {
//                print("\(String(describing: locationAnnotation.timestamp?.description))")
                if let onAnnotationSelection = parent.onAnnotationSelection {
                    onAnnotationSelection(locationAnnotation)
                }
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
            renderer.strokeColor = UIColor.white
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

