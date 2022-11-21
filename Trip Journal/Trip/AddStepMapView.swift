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
    var onRegionChange: ((MKCoordinateRegion) -> ())?
    
    func makeUIView(context: Context) -> MKMapView {

        let mapView = MKMapView()
        mapView.region = coordinateRegion

        mapView.selectableMapFeatures = [.pointsOfInterest, .physicalFeatures, .territories]
        let mapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic, emphasisStyle: .default)
        mapView.preferredConfiguration = mapConfiguration
        let pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.university])
        mapConfiguration.pointOfInterestFilter = pointOfInterestFilter
       
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(coordinateRegion, animated: true)
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
            return nil
            
//            let identifier = "Step"
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.markerTintColor = UIColor.systemIndigo
//            annotationView.titleVisibility = .hidden
//            annotationView.glyphImage = UIImage(systemName: "figure.walk")
//            return annotationView
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if let onRegionChange = parent.onRegionChange {
                onRegionChange(mapView.region)
            }
        }
    }
}
