//
//  PhotoGridView.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/12/2022.
//

import SwiftUI
import Photos


struct PhotoGridView: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    
//    let columns = [
//        GridItem(.adaptive(minimum: 150), spacing: 10)
//    ]

    let columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(photoLibraryService.results, id: \.localIdentifier) { asset in
                    HStack {
                        PhotoView(asset: asset)
                    }
                }
                .padding(10)
            }
        }
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView()
            .environmentObject(PhotoLibraryService.preview)
    }
}
