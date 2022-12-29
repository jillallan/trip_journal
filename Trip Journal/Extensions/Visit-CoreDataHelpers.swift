//
//  Visit-CoreDataHelpers.swift
//  Trip Journal
//
//  Created by Jill Allan on 28/12/2022.
//

import Foundation
import CoreData
import CoreLocation

extension Visit {
    
    convenience init(
        context: NSManagedObjectContext,
        latitude: Double,
        longitude: Double,
        horizontalAccuracy: Double,
        arrivalTimestamp: Date,
        departureTimestamp: Date
    ) {
        self.init(context: context)
        id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.horizontalAccuracy = horizontalAccuracy
        self.arrivalTimestamp = arrivalTimestamp
        self.departureTimestamp = departureTimestamp
    }
    
    convenience init(
        context: NSManagedObjectContext,
        visit: CLVisit
    ) {
        self.init(context: context, latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude, horizontalAccuracy: visit.horizontalAccuracy, arrivalTimestamp: visit.arrivalDate, departureTimestamp: visit.departureDate)
    }
    
    var visitArrivalTimestamp: Date {
        arrivalTimestamp ?? Date.now
    }
    
    var visitDepartureTimestamp: Date {
        departureTimestamp ?? Date.now
    }
    
    var locationId: UUID {
        id ?? UUID()
    }
}
