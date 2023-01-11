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
    
    // MARK: - Properties
    
    var tripTitle: String {
        title ?? "New Trip"
    }
    
    var tripStartDate: Date {
        startDate ?? Date.now
    }
    
    var tripEndDate: Date {
        endDate ?? Date.now
    }
    
    var tripEntries: [Entry] {
        entries?.allObjects as? [Entry] ?? []
    }
    
//    var tripEntriesSorted: [Entry] {
//        tripEntries.sorted { first, second in
//            return first.entryTimestamp < second.entryTimestamp
//        }
//    }
    
    var tripPhotosAssetIdentifiers: [PhotoAssetIdentifier] {
        photoAssetIdentifiers?.allObjects as? [PhotoAssetIdentifier] ?? []
    }
}

// MARK: - Xcode Preview

extension Trip {
    static var preview: Trip = {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext
        
        let trip = createSampleTrip(managedObjectContext: viewContext)
        let entries = Entry.createSampleEntries(managedObjectContext: viewContext, trip: trip)
        
        trip.entries = Set(entries) as NSSet
        
        return trip
    }()
    
    static func createSampleTrip(managedObjectContext: NSManagedObjectContext) -> Trip {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let startDate = "14/11/2022"
        let endDate = "20/11/2022"

        let trip = Trip(
            context: managedObjectContext,
            title: "Bedminster to Beijing, then Tibet",
            startDate: dateFormatter.date(from: startDate) ?? Date.now,
            endDate: dateFormatter.date(from: endDate) ?? Date.now
        )
        return trip
    }
}
