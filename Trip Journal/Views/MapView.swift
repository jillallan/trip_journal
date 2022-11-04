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
    
    @Binding var coordinateRegion: MKCoordinateRegion
    @ObservedObject var viewModel: MapViewModel
    let annotationItems: [MKAnnotation]
    
    init(coordinateRegion: Binding<MKCoordinateRegion>, viewModel: MapViewModel, annotationItems: [MKAnnotation]) {
        _coordinateRegion = coordinateRegion
        self.viewModel = viewModel
        self.annotationItems = annotationItems
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotations(annotationItems)
//        coordinateRegion = mapView.region
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.setRegion(coordinateRegion, animated: false)

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
        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard let annotationItemType = parent.annotationItems.first {
//                return nil
//            }
            
//            guard let annotationItem = annotation as annotationIt else { return nil }
            
            
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "step") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Step")
//            annotationView.tintColor = UIColor.blue
//            annotationView.titleVisibility = .visible
//            return annotationView
//        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            parent.coordinateRegion.center = mapView.centerCoordinate
            print("Did change: \(mapView.centerCoordinate)")
        }
    }
}

