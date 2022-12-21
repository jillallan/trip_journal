//
//  TripCard2.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI
import Photos

struct TripCard: View {
    
    // MARK: - Properties
    
    let trip: Trip
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        UnwrappedImage(asset: photoAssets.fetchResult.firstObject, withGradient: true)
            .photoGridItemStyle(aspectRatio: 1, cornerRadius: 24)
            .overlay {
                TripCardOverlay(trip: trip)
            }
        
            .onAppear {
                let assetIdentifiers = trip.tripPhotosAssetIdentifiers.compactMap(\.assetIdentifier)
                photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
            }
    }
}

struct TripCard2_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(trip: .preview)
    }
}
