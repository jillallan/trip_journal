//
//  PersistanceController.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/11/2022.
//

import CoreLocation
import Foundation

class PersistanceController: ObservableObject {
    @Published var steps: [Step] = []
    private var savePath = FileManager.documentsDirectoryURL.appendingPathComponent("savedSteps")
    
    init(inMemory: Bool = false) {
        if inMemory {
            savePath = URL(filePath: "dev/null")
        }
        
        do {
            let data = try Data(contentsOf: savePath)
            steps = try JSONDecoder().decode([Step].self, from: data)
        } catch {
            steps = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(steps)
            try data.write(to: savePath)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension PersistanceController {
    static var preview: PersistanceController = {
        let persistanceController = PersistanceController(inMemory: true)
        do {
            try persistanceController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return persistanceController
    }()
    
    func createSampleData() throws {

        for stepCounter in 1...5 {
            let step = Step(
                latitude: Double.random(in: 49.5...50.5),
                longitude: Double.random(in: -0.5...0.5),
                timestamp: Date.now,
                name: "Step \(stepCounter)"
            )
            steps.append(step)
        }
        save()
    }
}
