//
//  PhotoView.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/12/2022.
//

import SwiftUI
import Photos

struct Photo: View {
    
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    let asset: PHAsset
    @State var inputImage: UIImage?
    
    var body: some View {
        VStack {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .onAppear {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 600, height: 600),
                contentMode: .aspectFit,
                options: nil) { image, info in
                    if let image = image {
                        inputImage = image
                    }
                }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = PHAsset()
        let uiImage = UIImage(named: "seamonster")
        Photo(asset: asset, inputImage: uiImage)

        
    }
}
