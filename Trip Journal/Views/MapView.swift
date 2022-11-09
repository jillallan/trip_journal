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
    let annotationItems: [MKAnnotation]
    var callback: (CLLocationCoordinate2D) -> ()
    var counter = 0
    
//    init(coordinateRegion: MKCoordinateRegion, annotationItems: [MKAnnotation]) {
//        self.coordinateRegion = coordinateRegion
//        self.annotationItems = annotationItems
//    }
    
    func makeUIView(context: Context) -> MKMapView {
        print("will make MKMapView")
        let mapView = MKMapView()
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotations(annotationItems)
        mapView.delegate = context.coordinator
        print("did make MKMapView")
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("will update MKMapView")
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
//            guard let annotationItemType = parent.annotationItems.first.self else {
//                return nil
//            }
//            guard let annotationItem = annotation as parent.annotationItems.first.self else { return nil }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "step") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Step")
            annotationView.tintColor = UIColor.blue
            annotationView.titleVisibility = .visible
            return annotationView
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print("Did change: \(mapView.centerCoordinate)")

            if parent.counter > 0 {
                parent.callback(mapView.centerCoordinate)
            }
            parent.counter += 1
        }
    }
}

