//
//  TripTitleCardOverlay.swift
//  Trip Journal
//
//  Created by Jill Allan on 29/12/2022.
//

import SwiftUI

struct TripTitleCardOverlay: View {
    let trip: Trip
    @State var name: String
    @State private var startDate: Date
    @State private var endDate: Date
    
    init(trip: Trip) {
        self.trip = trip
        _name = State(initialValue: trip.tripTitle)
        _startDate = State(initialValue: trip.tripStartDate)
        _endDate = State(initialValue: trip.tripEndDate)
    }
    
    var body: some View {
        VStack() {
            VStack() {
                Text(trip.tripTitle)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
            }
            Spacer()
            HStack {
                DatePicker("Start", selection: $startDate.onChange(updateTrip), displayedComponents: .date)
                    .labelsHidden()
                DatePicker("End", selection: $endDate.onChange(updateTrip), displayedComponents: .date)
                    .labelsHidden()

            }
        }

        .padding()
        .foregroundColor(.white)
    
    }
    
    func updateTrip() {
        // TODO: - Navigating back to tripView does not refresh view
        
        trip.title = name
        trip.startDate = startDate
        trip.endDate = endDate
    }
}

struct TripTitleCardOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TripTitleCardOverlay(trip: .preview)
    }
}
