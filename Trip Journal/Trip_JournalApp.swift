//
//  Trip_JournalApp.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import SwiftUI

@main
struct Trip_JournalApp: App {
    @StateObject var persistanceController = PersistanceController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(persistanceController: persistanceController)
                .environmentObject(persistanceController)
            
        }
    }
}
