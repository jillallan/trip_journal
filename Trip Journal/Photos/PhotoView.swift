//
//  SwiftUIView.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/12/2022.
//

import SwiftUI
import Photos

struct PhotoView: View {
    let asset: PHAsset
    @State var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: (inputImage ?? UIImage(named: "seamonster"))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 600, height: 600)
                .cornerRadius(16)
                .clipped(antialiased: true)
        }
        .onAppear {
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 600, height: 600),
                contentMode: .aspectFit,
                options: nil) { image, info in
                    print("photo info: \(String(describing: info))")
                    if let image = image {
                        inputImage = image
                    }
                }
        }
    }
}

//struct Photoiew_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}
