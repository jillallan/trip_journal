//
//  StepCard2.swift
//  Trip Journal
//
//  Created by Jill Allan on 16/12/2022.
//

import SwiftUI
import Photos

struct StepCard: View {
    
    // MARK: - Properties
    
    let step: Step
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(step.stepName)
                    .font(.largeTitle.bold())
                Text(step.stepTimestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                Label(10.formatted(), systemImage: "figure.walk")
                Label(2360.formatted(), systemImage: "airplane")
            }
        }
        
        // MARK: - Grid Item aspect ratio
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .clipped(antialiased: true)
        .aspectRatio(1.6, contentMode: .fit)
        
        // MARK: - Grid item content appearance
        
        .padding()
        .foregroundColor(.white)
        .background(backgroundImage)
        .cornerRadius(24)
        
        // MARK: - Tasks
        
        .onAppear {
            let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
    }
}

extension StepCard {
    private var backgroundImage: some View {
        ZStack {
            if let asset = photoAssets.fetchResult.firstObject {
                PhotoGridItem(asset: asset, geometry: nil)
            } else {
                Color.accentColor
            }
            LinearGradient(
                colors: [Color(white: 0, opacity: 0.75), .clear],
                startPoint: .topLeading,
                endPoint: UnitPoint(x: 0.4, y: 1.0)
            )
        }
    }
}

struct StepCard_Previews: PreviewProvider {
    static var previews: some View {
        StepCard(step: .preview)
    }
}
