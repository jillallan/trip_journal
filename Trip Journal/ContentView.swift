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
            TripsView()
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            PhotoGridView()
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle.angled")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController.preview)
            .environmentObject(LocationManager.preview)
    }
}
