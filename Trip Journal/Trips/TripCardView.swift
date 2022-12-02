//
//  TripCardView.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/11/2022.
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip
    
    var body: some View {
        VStack {
            ZStack {
                Image("santa")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
            }
            VStack {
                HStack {
                    Text(trip.tripTitle)
                        .font(.title)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("\(trip.tripSteps.count) steps")
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Text(trip.tripStartDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("-")
                    Spacer()
                    Text(trip.tripEndDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
}

struct TripCardView_Previews: PreviewProvider {
    static var previews: some View {
        TripCardView(trip: .preview)
    }
}
