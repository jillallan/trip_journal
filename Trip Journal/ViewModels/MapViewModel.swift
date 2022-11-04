//
//  MapViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    @Published var steps = [Step]()
    @Published var region: MKCoordinateRegion
    
//    var mapRegion: MKCoordinateRegion {
//        let region: MKCoordinateRegion
//        if steps.first != nil {
//            region = MKCoordinateRegion(
//                center: steps.first?.coordinate ?? CLLocationCoordinate2D(latitude: 50, longitude: 0),
//                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
//        } else {
//            region = MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
//                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//            )
//        }
//        return region
//    }
    
    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    }
    
    func addStep() {
        let step = Step(coordinate: region.center, timestamp: Date.now, name: "New step")
        steps.append(step)
        print("step added at Lat: \(step.latitude), Lon: \(step.longitude)")
    }
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        let step = Step(coordinate: coordinate, timestamp: Date.now, name: "New step")
        steps.append(step)
        print("step added at Lat: \(step.latitude), Lon: \(step.longitude)")
    }
    
    func updateRegion() {
        // TODO: -
    }
}
