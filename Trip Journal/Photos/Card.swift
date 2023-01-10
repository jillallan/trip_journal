//
//  UnwrappedImage.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI
import Photos

struct Card: View {
    var asset: PHAsset?
    
    var body: some View {
        ZStack {
            if let asset = asset {
                Photo(asset: asset)
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

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card()
    }
}
