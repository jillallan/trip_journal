//
//  TripViewMapModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import CoreLocation
import Foundation
import MapKit

@MainActor class TripViewModel: ObservableObject {
    @Published var steps = [Step]()
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 58, longitude: 1),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )

//    init() {
//        region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
//            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//        )
//        if let stepRegion = steps.first?.region {
//            region = stepRegion
//        }
//    }
    
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        let step = Step(coordinate: coordinate, timestamp: Date.now, name: "New Step \(Date.now)")
        steps.append(step)
    }
    
    func setRegion() {
        if let newRegion = steps.last?.region {
            region = newRegion
        } else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
    }
    
    func setRegionToTripStart() {
        if let newRegion = steps.first?.region {
            region = newRegion
        } else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
}
