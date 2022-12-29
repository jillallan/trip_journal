//
//  EventLog.swift
//  Trip Journal
//
//  Created by Jill Allan on 28/12/2022.
//

import Foundation
import CoreData

extension EventLog {
    
    convenience init(
        context: NSManagedObjectContext,
        timestamp: Date,
        detail: String
    ) {
        self.init(context: context)
        id = UUID()
        self.timestamp = timestamp
        self.detail = detail
    }
    
    var eventLogTimestamp: Date {
        timestamp ?? Date.now
    }
    
    var eventLogId: UUID {
        id ?? UUID()
    }
    
    var eventLogDetail: String {
        detail ?? ""
    }
}
