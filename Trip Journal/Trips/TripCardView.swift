//
//  TripCardView.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/11/2022.
//

import SwiftUI
import Photos

struct TripCardView: View {
    let trip: Trip
    
    @State var photos = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        VStack {
            ZStack {
                if let asset = photos.fetchResult.firstObject {
                    PhotoGridItemView(asset: asset)
                }

//                Image("santa")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
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
        .onAppear {
            let assetIdentifiers = trip.tripPhotos.compactMap(\.assetIdentifier)
            print("assetIdentifiers tripsView: \(assetIdentifiers)")
            photos.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
    }
}

struct TripCardView_Previews: PreviewProvider {
    static var previews: some View {
        TripCardView(trip: .preview)
    }
}
