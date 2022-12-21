//
//  Location.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/12/2022.
//

import Foundation
import CoreData

extension Location {
    
    convenience init(
        context: NSManagedObjectContext,
        latitude: Double,
        longitude: Double,
        timestamp: Date
    ) {
        self.init(context: context)
        id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
    
    var stepTimestamp: Date {
        timestamp ?? Date.now
    }
}
