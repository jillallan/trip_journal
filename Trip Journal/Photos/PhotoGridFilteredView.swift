//
//  PhotoGridFilteredView.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/12/2022.
//

import Photos
import SwiftUI

struct PhotoGridFilteredView: View {
    
    let trip: Trip
    
    @EnvironmentObject var dataController: DataController
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    let columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(photoAssets, id: \.localIdentifier) { asset in
                    HStack {
                        PhotoGridItemView(asset: asset)
                    }
                }
                .padding(10)
            }
        }
        .onAppear {
            let assetIdentifiers = trip.tripPhotosAssetIdentifiers.compactMap(\.assetIdentifier)
            print("assetIdentifiers filteredGridView: \(assetIdentifiers)")
            photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
    }
}

struct PhotoGridFilteredView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridFilteredView(trip: .preview)
    }
}
