//
//  PersistanceControllerCD.swift
//  Trip Journal
//
//  Created by Jill Allan on 16/11/2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Data")
    }
}
