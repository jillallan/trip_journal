//
//  UnwrappedImage.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI
import Photos

struct UnwrappedImage: View {
    var asset: PHAsset?
    var withGradient: Bool = false
    
    var body: some View {
        ZStack {
            if let asset = asset {
                Photo(asset: asset)
            } else {
                Color.accentColor
            }
            if withGradient {
                LinearGradient(
                    colors: [Color(white: 0, opacity: 0.75), .clear],
                    startPoint: .topLeading,
                    endPoint: UnitPoint(x: 0.4, y: 1.0)
                )
            }
            
        }
    }
}

//struct UnwrappedImage_Previews: PreviewProvider {
//    static var previews: some View {
//        UnwrappedImage()
//    }
//}
