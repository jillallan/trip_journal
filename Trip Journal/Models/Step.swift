//
//  Step.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import Foundation
import MapKit

class Step: NSObject, Codable, Identifiable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let name: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
    init(latitude: Double, longitude: Double, timestamp: Date, name: String) {
        self.id = UUID()
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

extension Step {
    static var preview: Step {
        Step(latitude: 51.1, longitude: 0.0, timestamp: Date.now, name: "Step 1")
    }
    
    static var previews: [Step] {
        [
            Step(latitude: 51.1, longitude: 0.0, timestamp: Date.now, name: "Step 1"),
            Step(latitude: 51.2, longitude: 0.5, timestamp: Date.now, name: "Step 2"),
            Step(latitude: 51.3, longitude: 0.8, timestamp: Date.now, name: "Step 3"),
            Step(latitude: 51.4, longitude: 1.1, timestamp: Date.now, name: "Step 4")
        ]
    }

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
