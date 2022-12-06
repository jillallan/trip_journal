//
//  Trip.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import CoreData
import Foundation
import MapKit

extension Trip {
    convenience init(context: NSManagedObjectContext, title: String, startDate: Date, endDate: Date) {
        self.init(context: context)
        id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
    
    // MARK: - Properties View API
    
    var tripTitle: String {
        title ?? "New Trip"
    }
    
    var tripStartDate: Date {
        startDate ?? Date.now
    }
    
    var tripEndDate: Date {
        endDate ?? Date.now
    }
    
    var tripSteps: [Step] {
        steps?.allObjects as? [Step] ?? []
    }
    
    var tripPhotos: [Photo] {
        photos?.allObjects as? [Photo] ?? []
    }
}

// MARK: - Xcode Preview

extension Trip {
    static var preview: Trip = {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext
        
        let trip = createSampleTrip(managedObjectContext: viewContext)
        let steps = Step.createSampleSteps(managedObjectContext: viewContext, trip: trip)
        
        trip.steps = Set(steps) as NSSet
        
        return trip
    }()
    
    static func createSampleTrip(managedObjectContext: NSManagedObjectContext) -> Trip {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let startDate = "14/11/2022"
        let endDate = "20/11/2022"

        let trip = Trip(
            context: managedObjectContext,
            title: "France",
            startDate: dateFormatter.date(from: startDate) ?? Date.now,
            endDate: dateFormatter.date(from: endDate) ?? Date.now
        )
        return trip
    }
}
