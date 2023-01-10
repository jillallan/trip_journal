//
//  TripTitleCard.swift
//  Trip Journal
//
//  Created by Jill Allan on 29/12/2022.
//

import SwiftUI
import Photos

struct TripTitleCard: View {
    let trip: Trip

    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        Card(asset: photoAssets.fetchResult.firstObject)
            .photoGridItemStyle(aspectRatio: 1.4, cornerRadius: 0)
            .overlay {
                TripTitleCardOverlay(trip: trip)
            }
        
            .onAppear {
                let assetIdentifiers = trip.tripPhotosAssetIdentifiers.compactMap(\.assetIdentifier)
                photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
            }
    }
}

//struct TripTitleCard_Previews: PreviewProvider {
//    static var previews: some View {
//        TripTitleCard()
//    }
//}
