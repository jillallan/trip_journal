//
//  PhotoView.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/12/2022.
//

import SwiftUI
import Photos

struct PhotoGridItemView: View {
    let asset: PHAsset
    @State var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: (inputImage ?? UIImage(named: "seamonster"))!)
                .resizable()
                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(16)
                .clipped(antialiased: true)
        }
        .onAppear {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 200, height: 200),
                contentMode: .aspectFit,
                options: nil) { image, info in
                    if let image = image {
                        inputImage = image
                    }
                }
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
//        let asset = fetchResult.firstObject!
//
////        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [Photo.preview.photoAssetIdentifier], options: nil).firstObject!
//
//        PhotoView(asset: asset)
//    }
//}
