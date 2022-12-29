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
    @StateObject var photoLibraryService: PhotoLibraryService
    
    init() {
        // create access to the data controller
        // (not just the stateobject wrapper, so we can pass it in to environment object below
        let dataController = DataController()
        let locationManager = LocationManager(dataController: dataController)
        let photoLibraryService = PhotoLibraryService(dataController: dataController)
        _dataController = StateObject(wrappedValue: dataController)
        _locationManager = StateObject(wrappedValue: locationManager)
        _photoLibraryService = StateObject(wrappedValue: photoLibraryService)
        
        print("app launched")
        
        photoLibraryService.getPermissionIfNecessary { granted in
            photoLibraryService.cacheAllAssets2()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
            // Inject dataController and locationManager into the environment so we can reference them from any view
                .environmentObject(dataController)
                .environmentObject(locationManager)
                .environmentObject(photoLibraryService)
                
            
        }
    }
}
