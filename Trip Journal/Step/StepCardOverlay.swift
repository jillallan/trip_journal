//
//  StepCardOverlay.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI

struct StepCardOverlay: View {
    let step: Step
//    @FetchRequest var steps: FetchedResults<Step>
//    @FetchRequest var PhotoAssetIdentifier: FetchedResults<PhotoAssetIdentifier>
    
//    init(trip: Trip) {
//        self.trip = trip
//        _steps = FetchRequest<Step>(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
//            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
//        )
        
//        let tripStartPredicate = NSPredicate(format: "timestamp > %@", trip.tripStartDate as CVarArg)
//        let tripEndPredicate = NSPredicate(format: "timestamp < %@", trip.tripEndDate as CVarArg)
//        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [tripStartPredicate, tripEndPredicate])
//
//        _locations = FetchRequest<Location>(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
//            predicate: compoundPredicate
//        )
    
    var body: some View {
        VStack() {
            VStack() {
                Text(step.stepName)
                    .font(.headline)
//                    .multilineTextAlignment(.leading)
                Text(step.stepTimestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                metricsLabel(count: step.stepPhotoAssetIdentifiers.count, units: "photos", systemImage: "photo.on.rectangle.angled")
            }
        }
        .padding()
        .foregroundColor(.white)
    }
}

//struct StepCardOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        StepCardOverlay(step: .preview)
//    }
//}
