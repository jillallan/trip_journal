//
//  TripCardText.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI

struct TripCardOverlay: View {
    let trip: Trip
    @FetchRequest var steps: FetchedResults<Step>
    @FetchRequest var locations: FetchedResults<Location>
    
    init(trip: Trip) {
        self.trip = trip
        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
        
        let tripStartPredicate = NSPredicate(format: "timestamp > %@", trip.tripStartDate as CVarArg)
        let tripEndPredicate = NSPredicate(format: "timestamp < %@", trip.tripEndDate as CVarArg)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [tripStartPredicate, tripEndPredicate])
        
        _locations = FetchRequest<Location>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
            predicate: compoundPredicate
        )
    }
    
    var body: some View {
        VStack() {
            VStack() {
                Text(trip.tripTitle)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .layoutPriority(1)
                Text(trip.tripStartDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                metricsLabel(count: steps.count, units: "steps", systemImage: "figure.walk")
                metricsLabel(count: Int(locations.map(\.distance).reduce(0.0, +)) / 1000, units: "km", systemImage: "road.lanes")
            }
        }
        .padding()
        .foregroundColor(.white)
    }
}

//struct TripCardText_Previews: PreviewProvider {
//    static var previews: some View {
//        TripCardOverlay(trip: .preview)
//    }
//}
