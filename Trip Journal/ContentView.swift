//
//  ContentView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//
import CoreLocation
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TripViewModel()
    let persistanceController: PersistanceController
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    var body: some View {
        TabView {
            
            TripView(viewModel: viewModel)
            
                .tabItem {
                    Label("Map", systemImage: "map")
                    
            }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "calendar.day.timeline.trailing")
                }
        }
        
//        NavigationStack {
//            List {
//                NavigationLink("Trip") {
//                    TripView(viewModel: viewModel)
//                }
//            }
//            .navigationTitle("Trip Journal")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(persistanceController: .preview)
    }
}
