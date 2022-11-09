//
//  MapViewUIView.swift
//  Trip Journal
//
//  Created by Jill Allan on 03/11/2022.
//

import Foundation
import MapKit
import SwiftUI

struct MapViewSimple: UIViewRepresentable {
    
    @Binding var coordinateRegion: MKCoordinateRegion
    var callback: (CLLocationCoordinate2D) -> ()
    var counter = 0
    
//    init(coordinateRegion: MKCoordinateRegion, annotationItems: [MKAnnotation]) {
//        self.coordinateRegion = coordinateRegion
//        self.annotationItems = annotationItems
//    }
    
    func makeUIView(context: Context) -> MKMapView {
        print("will make MKMapViewSimple")
        let mapView = MKMapView()
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.delegate = context.coordinator
        print("did make MKMapViewSimple")
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("will update MKMapViewSimple")
        print("did update MKMapViewSimple")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    typealias UIViewType = MKMapView

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewSimple
        
        init(parent: MapViewSimple) {
            self.parent = parent
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
