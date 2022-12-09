//
//  StepViewCell.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import SwiftUI
import Photos

struct TripViewStepCell: View {
    let step: Step
    
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())

    var body: some View {
        ZStack {
            // TODO: -
            if let asset = photoAssets.fetchResult.firstObject {
                PhotoGridItemView(asset: asset)
            }
            Text(step.stepName)
                .font(.title)
                .foregroundColor(.white)
        }
        
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//                Text(step.stepName)
//                    .font(.headline)
//                    .foregroundColor(.accentColor)
//                HStack {
//                    Text(step.stepTimestamp, style: .date)
//                    Text(step.stepTimestamp, style: .time)
//                }
//            }
//        }
        .onAppear {
            let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
    }
    
}

struct StepViewCell_Previews: PreviewProvider {
    static var previews: some View {
        TripViewStepCell(step: .preview)
    }
}
