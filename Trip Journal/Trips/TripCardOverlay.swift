//
//  TripCardText.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI

struct TripCardOverlay: View {
    let trip: Trip
    
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
                metricsLabel(count: 10, systemImage: "figure.walk")
                metricsLabel(count: 2360, systemImage: "airplane")
            }
        }
        .padding()
        .foregroundColor(.white)
    }
}

struct TripCardText_Previews: PreviewProvider {
    static var previews: some View {
        TripCardOverlay(trip: .preview)
    }
}
