//
//  PersistanceControllerCD.swift
//  Trip Journal
//
//  Created by Jill Allan on 16/11/2022.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
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
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}

extension DataController {
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
        
//        let trip = Trip.preview
        

        for tripCounter in 1...3 {
            let trip = Trip(context: viewContext, title: "Test Trip \(tripCounter)", startDate: Date.now, endDate: Date(timeIntervalSinceNow: 86400))
            trip.steps = []

            for stepCounter in 1...5 {
                let step = Step(
                    context: viewContext,
                    latitude: Double.random(in: 51.0...52.0),
                    longitude: -Double.random(in: 2...3),
                    timestamp: Date.now,
                    name: "Step \(stepCounter)"
                )
                step.trip = trip
            }
        }

        try viewContext.save()
    }
}
