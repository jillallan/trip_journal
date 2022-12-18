//
//  TripCard.swift
//  Trip Journal
//
//  Created by Jill Allan on 16/12/2022.
//

// https://levelup.gitconnected.com/create-custom-view-components-in-swiftui-845b65e8ba94
// https://talk.objc.io/episodes/S01E309-building-a-photo-grid-square-grid-cells?t=146

import SwiftUI
import Photos

struct TripCard: View {
    
    // MARK: - Properties
    
    let trip: Trip
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(trip.tripTitle)
                    .font(.largeTitle.bold())
                Text(trip.tripStartDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                Label(10.formatted(), systemImage: "figure.walk")
                Label(2360.formatted(), systemImage: "airplane")
            }
        }
        
        // MARK: - Grid Item aspect ratio
        
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .clipped(antialiased: true)
        .aspectRatio(1, contentMode: .fit)
        
        // MARK: - Grid item content appearance
        
        .padding()
        .foregroundColor(.white)
        .background(backgroundImage)
        .cornerRadius(24)
        
        // MARK: - Tasks
        
        .onAppear {
            let assetIdentifiers = trip.tripPhotosAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
    }
}

extension TripCard {
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

struct TripCard_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(trip: .preview)
    }
}