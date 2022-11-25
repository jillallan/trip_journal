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
}

//extension Trip {
//    static var preview: Trip = {
//        let dataController = DataController.preview
//        let managedObjectContext = dataController.container.viewContext
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yy"
//        
//        let startDate = "14/11/2022"
//        let endDate = "20/11/2022"
//        
//        let trip = Trip(
//            context: managedObjectContext,
//            title: "France",
//            startDate: dateFormatter.date(from: startDate) ?? Date.now,
//            endDate: dateFormatter.date(from: endDate) ?? Date.now
//        )
//        for step in Step.stepsPreview {
//            trip.addToSteps(step)
//        }
////        trip.steps = []
//        return trip
//    }()
//}
