//
//  AddStepMapView.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/11/2022.
//

import Foundation
import MapKit
import SwiftUI

struct AddStepMapView: UIViewRepresentable {
    var coordinateRegion: MKCoordinateRegion
    let annotationItems: [MKAnnotation]?
    var onRegionChange: ((MKCoordinateRegion) -> ())?
    var onAnnotationSelection: ((MKMapFeatureAnnotation) -> ())?
    
    func makeUIView(context: Context) -> MKMapView {

        let mapView = MKMapView()
        mapView.region = coordinateRegion

        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        let mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
        mapView.preferredConfiguration = mapConfiguration
        let pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.university])
        mapConfiguration.pointOfInterestFilter = pointOfInterestFilter
        
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
       
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(coordinateRegion, animated: true)
        if let annotationItems = annotationItems {
            mapView.addAnnotations(annotationItems)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    typealias UIViewType = MKMapView

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AddStepMapView
        
        init(parent: AddStepMapView) {
            self.parent = parent
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let identifier = "feature"
            if let featureAnnotation = annotation as? MKMapFeatureAnnotation? {
                let featureAnnotationView = MKMarkerAnnotationView(annotation: featureAnnotation, reuseIdentifier: nil)
                featureAnnotationView.markerTintColor = featureAnnotation?.iconStyle?.backgroundColor
                featureAnnotationView.selectedGlyphImage = featureAnnotation?.iconStyle?.image
                featureAnnotationView.glyphImage = featureAnnotation?.iconStyle?.image
                
                return featureAnnotationView
            }
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            return annotationView
            
//            let identifier = "Step"
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.markerTintColor = UIColor.systemIndigo
//            annotationView.titleVisibility = .hidden
//            annotationView.glyphImage = UIImage(systemName: "figure.walk")
//            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
//            let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
            if let onAnnotationSelection = parent.onAnnotationSelection {
                onAnnotationSelection(featureAnnotation)
            }
            
//            print(featureAnnotation.description)
            
//            Task {
//                do {
//                    guard let featureItem = try await featureRequest.mapItem else { return }
//                    UIView.animate(withDuration: 4) {
//                        self.animateCamera(featureItem)
//                    } completion: { _ in
//                        self.showInfoCardView
//                    }
//
//                } catch {
//
//                }
//            }
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if let onRegionChange = parent.onRegionChange {
                onRegionChange(mapView.region)
            }
        }
    }
}
