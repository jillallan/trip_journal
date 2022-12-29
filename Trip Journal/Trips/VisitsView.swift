//
//  Visits.swift
//  Trip Journal
//
//  Created by Jill Allan on 28/12/2022.
//

import SwiftUI

struct VisitsView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Visit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Visit.arrivalTimestamp, ascending: true)]
    ) var visits: FetchedResults<Visit>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(visits) { visit in
                    VStack {
                        HStack {
                            Text("Arrival Date")
                            Text(visit.visitArrivalTimestamp, style: .date)
                            Text(visit.visitArrivalTimestamp, style: .time)
                            Text("Departure Date")
                            Text(visit.visitDepartureTimestamp, style: .date)
                            Text(visit.visitDepartureTimestamp, style: .time)
                        }
                        HStack {
                            Text("Lat:")
                            Text(visit.latitude, format: .number)
                            Text("Lon:")
                            Text(visit.longitude, format: .number)
                            Text("Horizontal Accuracy")
                            Text(visit.horizontalAccuracy, format: .number)
                        }

                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Visits")
        }
    }
}
    

struct Visits_Previews: PreviewProvider {
    static var previews: some View {
        VisitsView()
    }
}
