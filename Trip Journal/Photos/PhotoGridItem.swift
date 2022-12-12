//
//  PhotoView.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/12/2022.
//

import SwiftUI
import Photos

struct PhotoGridItem: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    let asset: PHAsset
    let geometry: GeometryProxy!
    @State var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: (inputImage ?? UIImage(named: "seamonster"))!)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: (geometry != nil) ? geometry?.size.width : .infinity, maxHeight: 300)
                .cornerRadius(16)
                .clipped(antialiased: true)
        }
        .onAppear {
            photoLibraryService.imageCachingManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 600, height: 600),
                contentMode: .aspectFill,
                options: nil
            ) { image, info in
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
        PhotoView(asset: asset)
    }
}
