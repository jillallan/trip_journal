//
//  EntryCard.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI
import Photos

struct EntryCard: View {
    let entry: Entry
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        Card(asset: photoAssets.fetchResult.firstObject)
            .photoGridItemStyle(aspectRatio: 1.6, cornerRadius: 0)
            .overlay {
                EntryCardOverlay(entry: entry)
            }
        
            .onAppear {
                let assetIdentifiers = entry.entryPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
                photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
            }
    }
}

//struct EntryCard_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryCard(entry: .preview)
//    }
//}
