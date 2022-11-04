//
//  ContentView.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//
import CoreLocation
import SwiftUI

struct ContentView: View {
    @State var london = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.1167)
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Map View") {
                    TripView()
                }
                NavigationLink("") {
                    
                }
            }
            .navigationTitle("Trip Journal")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
