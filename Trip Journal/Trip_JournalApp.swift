//
//  Trip_JournalApp.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import SwiftUI

@main
struct Trip_JournalApp: App {
    @StateObject var dataController: DataController
    @StateObject var locationManager: LocationManager
    
    init() {
        // create access to the data controller
        // (not just the stateobject wrapper, so we can pass it in to environment object below
        let dataController = DataController()
        let locationManager = LocationManager()
        _dataController = StateObject(wrappedValue: dataController)
        _locationManager = StateObject(wrappedValue: locationManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(locationManager)
            
        }
    }
}
