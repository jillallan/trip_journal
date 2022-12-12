//
//  PhotoGridView.swift
//  Trip Journal
//
//  Created by Jill Allan on 06/12/2022.
//

import SwiftUI
import Photos


struct PhotoGridView: View {
    @EnvironmentObject var dataController: DataController

    @FetchRequest(
        entity: PhotoAssetIdentifier.entity(),
        sortDescriptors: []
    ) var photoAssetIdentifiers: FetchedResults<PhotoAssetIdentifier>

    @State var photosAssets = PHFetchResultCollection(fetchResult: .init())

    let columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(photosAssets, id: \.localIdentifier) { asset in
                        NavigationLink {
                            PhotoView(asset: asset)
                        } label: {
                            PhotoGridItem(asset: asset, geometry: nil)
                        }
                    }
                    .padding(10)
                }
            }
            .onAppear {
                let assetIdentifiers = photoAssetIdentifiers.compactMap(\.assetIdentifier)
                let fetchOptions = PHFetchOptions()
                fetchOptions.includeHiddenAssets = false
                fetchOptions.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]
                photosAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: fetchOptions)
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
