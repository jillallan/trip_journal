//
//  Location.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/12/2022.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

extension Location {
    
    convenience init(
        context: NSManagedObjectContext,
        latitude: Double,
        longitude: Double,
        altitude: Double,
        horizontalAccuracy: Double,
        verticalAccuracy: Double,
        timestamp: Date
    ) {
        self.init(context: context)
        id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.timestamp = timestamp
    }
    
    convenience init(
        context: NSManagedObjectContext,
        cLlocation: CLLocation
    ) {
        self.init(context: context, latitude: cLlocation.coordinate.latitude, longitude: cLlocation.coordinate.longitude, altitude: cLlocation.altitude, horizontalAccuracy: cLlocation.horizontalAccuracy, verticalAccuracy: cLlocation.verticalAccuracy, timestamp: cLlocation.timestamp)
    }
    
    var locationTimestamp: Date {
        timestamp ?? Date.now
    }
}

extension Location: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
