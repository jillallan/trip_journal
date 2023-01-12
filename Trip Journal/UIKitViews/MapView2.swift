//
//  MapView2.swift
//  Trip Journal
//
//  Created by Jill Allan on 03/11/2022.
//

import CoreData
import Foundation
import MapKit
import SwiftUI

struct MapView2: UIViewRepresentable {
    
    // MARK: - Properties
    @Binding var centre: CLLocationCoordinate2D
    @Binding var span: MKCoordinateSpan
    var annotationItems: [MKAnnotation]?
    var annotationsDidChange: Bool
    let routeOverlay: [MKPolyline]?
    @Binding var selectedAnnotation: MKAnnotation?
    var onRegionChange: ((MKCoordinateRegion) -> ())?
    
    
//    var onAnnotationSelection: ((MKAnnotation) -> ())?
    // TODO: - Add on location count change closure
    
    // MARK: - Protocol Methods
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
        let pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.university])
        
        mapView.region = MKCoordinateRegion(center: centre, span: span)
        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        mapView.preferredConfiguration = mapConfiguration
        
        mapConfiguration.pointOfInterestFilter = pointOfInterestFilter

        
        if let annotationItems = annotationItems {
            
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            mapView.addAnnotations(annotationItems)
        }
        
        
        if let routeOverlay = routeOverlay {
            if !mapView.overlays.isEmpty {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlays(routeOverlay)
        }
        mapView.delegate = context.coordinator
        return mapView
    }
    
    
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(MKCoordinateRegion(center: centre, span: span), animated: true)
        mapView.showsUserLocation = true
//        mapView.preferredConfiguration = mapViewConfiguration
        
        if let annotationItems = annotationItems {
            if annotationsDidChange {
                if !mapView.annotations.isEmpty {
                    mapView.removeAnnotations(mapView.annotations)
                }
                mapView.addAnnotations(annotationItems)
            }
            
            
            // TODO: - only remove and add annotations if location count change
            // TODO: - remove and add if entry or location changes - force view update
            mapView.addAnnotations(annotationItems)
        }
        
        if let routeOverlay = routeOverlay {
            // TODO: - remove and add if entry or location changes - force view update
            if annotationsDidChange {
                if !mapView.overlays.isEmpty {
                    mapView.removeOverlays(mapView.overlays)
                }
                mapView.addOverlays(routeOverlay)
            }
            mapView.addOverlays(routeOverlay)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(centre: $centre, span: $span, selectedAnnotation: $selectedAnnotation)
    }
    
    typealias UIViewType = MKMapView

    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selectedAnnotation: MKAnnotation?
        @Binding var centre: CLLocationCoordinate2D
        @Binding var span: MKCoordinateSpan
        
        init(centre: Binding<CLLocationCoordinate2D>,
             span: Binding<MKCoordinateSpan>,
             selectedAnnotation: Binding<MKAnnotation?>
        ) {
            _centre = centre
            _span = span
            _selectedAnnotation = selectedAnnotation
        }
        
        // MARK: - Delegate Methods
        
        
        // MARK: - Annotations
        
        @MainActor func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self) {
                // TODO: - Add custom annotation
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

            
            let stepIdentifier = "step"
            if let stepAnnotation = annotation as? Step {
                let stepAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: stepIdentifier) ?? MKAnnotationView(annotation: stepAnnotation, reuseIdentifier: stepIdentifier)

                if stepAnnotation.entry != nil {
                    if let photoAnnotation = renderAnnotationEntry() {
                        stepAnnotationView.image = photoAnnotation
                        return stepAnnotationView
                    }
                } else {
                    if let circleAnnotation = renderAnnotationCircle() {
                        stepAnnotationView.image = circleAnnotation
                        return stepAnnotationView
                    }
                }
            }
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
        
        @MainActor func renderAnnotationEntry() -> UIImage? {
            let renderer = ImageRenderer(content: EntryAnnotation())
            // TODO: Pass displayScale environment variable in from swiftui view
            // https://developer.apple.com/documentation/swiftui/environmentvalues/displayscale/
            renderer.scale = 3.0
            
            guard let uiImage = renderer.uiImage else { return nil }
            return uiImage
         
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
            if let featureAnnotation = annotation as? MKMapFeatureAnnotation {
                selectedAnnotation = featureAnnotation
            }
            
            if let stepAnnotation = annotation as? Step {
                selectedAnnotation = stepAnnotation
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
            centre = mapView.region.center
            span = mapView.region.span
        }
    }
}

