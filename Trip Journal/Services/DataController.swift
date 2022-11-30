//
//  PersistanceControllerCD.swift
//  Trip Journal
//
//  Created by Jill Allan on 16/11/2022.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    // MARK: - Properties
    
    let container: NSPersistentContainer
    
    // MARK: - Init
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Update data model
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
}

extension DataController {
    
    // MARK: - Xcode Preview
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
        
        let trip = Trip.createSampleTrip(managedObjectContext: viewContext)
        let steps = Step.createSampleSteps(managedObjectContext: viewContext, trip: trip)
        trip.steps = Set(steps) as NSSet
        
        try viewContext.save()
    }
}

extension DataController: Equatable {
    static func == (lhs: DataController, rhs: DataController) -> Bool {
        return lhs.container == rhs.container
    }
}
