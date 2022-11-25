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
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        TabView {
            TripsView(dataController: dataController, locationManager: locationManager)
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(persistanceController: .preview)
//    }
//}
