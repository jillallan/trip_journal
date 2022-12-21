//
//  StepCard2.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI
import Photos

struct StepCard: View {
    let step: Step
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        UnwrappedImage(asset: photoAssets.fetchResult.firstObject, withGradient: true)
            .photoGridItemStyle(aspectRatio: 1.6, cornerRadius: 1)
            .overlay {
                StepCardOverlay(step: step)
            }
        
            .onAppear {
                let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
                photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
            }
    }
}

struct StepCard2_Previews: PreviewProvider {
    static var previews: some View {
        StepCard(step: .preview)
    }
}
