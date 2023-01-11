//
//  LocationsListView.swift
//  Trip Journal
//
//  Created by Jill Allan on 28/12/2022.
//

import SwiftUI

struct LocationsView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Location.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]
    ) var locations: FetchedResults<Location>
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Location Count")
                    Text(locations.count, format: .number)
                }
                ForEach(locations) { location in
                    VStack {
                        HStack {
                            Text(location.locationTimestamp, style: .date)
                            Text(location.locationTimestamp, style: .time)
                            Text(location.latitude, format: .number)
                            Text(location.longitude, format: .number)
                        }
                        HStack {
                            Text("Distance")
                            Text(location.distance, format: .number)
                            Text("Horizontal Accuracy")
                            Text(location.horizontalAccuracy, format: .number)
                            Text("Speed")
                            Text(location.speed, format: .number)
                            Text("Calc Speed")
                            Text(location.calculatedSpeed, format: .number)
                        }
                        HStack {
                            Text(location.entry?.entryName ?? "No entry")
                        }
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Locations")
        }
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
    }
}
