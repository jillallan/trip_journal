//
//  ContentView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//
import CoreLocation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        TabView {
            
//            TripView(dataController: dataController)
//                .tabItem {
//                    Label("Map", systemImage: "map")
//
//            }
            TripsView(dataController: dataController)
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "calendar.day.timeline.trailing")
                }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(persistanceController: .preview)
//    }
//}
