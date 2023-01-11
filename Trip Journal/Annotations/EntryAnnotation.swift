//
//  EntryAnnotation.swift
//  Trip Journal
//
//  Created by Jill Allan on 23/12/2022.
//

import SwiftUI
import Photos

struct EntryAnnotation: View {
//    let photoAssetIdentifiers: [PhotoAssetIdentifier]
//    @State var photosAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
            Circle()
                .fill(Color.teal)
                .frame(width: 18, height: 18)
//            if let photoAsset = photosAssets[0] {
//                JournalImage(asset: photoAsset)
//                    .clipped()
//                    .clipShape(Circle())
//                    .frame(width: 40, height: 40)
//            } else {
//
//            }
        }
//        .onAppear {
//            let assetIdentifiers = photoAssetIdentifiers.compactMap(\.assetIdentifier)
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.includeHiddenAssets = false
//            fetchOptions.sortDescriptors = [
//                NSSortDescriptor(key: "creationDate", ascending: false)
//            ]
//            photosAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: fetchOptions)
//
//
//
//        }
//        .background(Color.black)
        
    }
}

//struct EntryAnnotation_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryAnnotation()
//    }
//}
