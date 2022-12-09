//
//  StepViewCell.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import SwiftUI
import Photos

struct StepCardView: View {
    let step: Step
    let geometry: GeometryProxy
    
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            if let asset = photoAssets.fetchResult.firstObject {
                PhotoGridItemView(asset: asset, geometry: geometry)
            }
//            Text(step.stepName)
//                .font(.title)
//                .foregroundColor(.white)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(step.stepName)
                        .font(.headline)
                    HStack {
                        Text(step.stepTimestamp, style: .date)
                        Text(step.stepTimestamp, style: .time)
                    }
                    .font(.subheadline)
                }
                .foregroundColor(.white)
            }
            .padding(12)

            
//            HStack {
//                VStack {
//                    Spacer()
//                    Text(step.stepName)
//                        .font(.title)
//                        .foregroundColor(.white)
//                    Text(step.stepTimestamp, style: .date)
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//
//                }
//                Spacer()
//            }
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

//struct StepViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        StepCardView(step: .preview)
//    }
//}
