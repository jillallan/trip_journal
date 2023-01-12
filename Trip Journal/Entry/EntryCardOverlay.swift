//
//  EntryCardOverlay.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI

struct EntryCardOverlay: View {
    let entry: Entry
    
    var body: some View {
        VStack() {
            VStack() {
                Text(entry.entryName)
                    .font(.headline)
//                    .multilineTextAlignment(.leading)
                Text(entry.entryTimestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                metricsLabel(count: entry.entryPhotoAssetIdentifiers.count, units: "photos", systemImage: "photo.on.rectangle.angled")
            }
        }
        .padding()
        .foregroundColor(.white)
    }
}

//struct EntryCardOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryCardOverlay(entry: .preview)
//    }
//}
