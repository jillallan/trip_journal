//
//  ContentView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//
import CoreLocation
import SwiftUI

struct ContentView: View {
    let persistanceController: PersistanceController
    @StateObject var viewModel: TripViewModel
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
        let viewModel = TripViewModel(persistanceController: persistanceController)
        _viewModel = StateObject(wrappedValue: viewModel)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(persistanceController: .preview)
    }
}
