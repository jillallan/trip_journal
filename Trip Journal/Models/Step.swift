//
//  Step.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import Foundation
import MapKit

class Step: NSObject, Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let name: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, timestamp: Date, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.name = name
    }
    
    convenience init(coordinate: CLLocationCoordinate2D, timestamp: Date, name: String) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude, timestamp: timestamp, name: name)
    }
}

extension Step: MKAnnotation {
    var title: String? { name }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && rhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == lhs.center && rhs.span == lhs.span
    }
}
