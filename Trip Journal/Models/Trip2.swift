//
//  Trip.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/11/2022.
//

import Foundation
import MapKit

struct Trip2 {
    let id = UUID()
    let startLatitude: Double // replace with center calculated from trip steps
    let startLongitude: Double // replace with center calculated from trip steps
    let timestamp: Date
    let name: String
    var steps: [Step]
    
    // replace with center calculated from trip steps
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: steps.map(\.latitude).reduce(0, +) / Double(steps.count),
            longitude: steps.map(\.latitude).reduce(0, +) / Double(steps.count)
        )
    }
    

    
//    var rect: MKMapRect {
//        MKMapRect(
//            origin: MKMapPoint(coordinate),
//            size: MKMapSize(
//                width: steps.map(\.longitude).map({ longitude in
//                    max(longitude)
//                }),
//                height:  )
//        )
//    }
//
    // replace with center calculated from trip steps
    var span: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    }
    
    // replace with center calculated from trip steps
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: span)
    }
}
