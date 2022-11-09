//
//  SimpleStep.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/11/2022.
//

import MapKit
import Foundation

struct SimpleStep: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let name: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    }
}

extension SimpleStep {
    init(coordinate: CLLocationCoordinate2D, timestamp: Date, name: String) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude, timestamp: timestamp, name: name)
    }
}
