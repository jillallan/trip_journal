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
        GridItem(spacing: 3),
        GridItem(spacing: 3)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(photosAssets, id: \.localIdentifier) { asset in
                        NavigationLink {
                            Thumbnail(asset: asset)
                        } label: {
                            Photo(asset: asset)
                                .photoGridItemStyle(aspectRatio: 1, cornerRadius: 0)
                        }
                    }
                    
                }
//                .padding(3)
            }
            .navigationTitle("Photos")
//            .ignoresSafeArea(edges: .top)
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
