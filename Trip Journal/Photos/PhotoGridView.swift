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
        entity: Photo.entity(),
        sortDescriptors: []
    ) var photos: FetchedResults<Photo>
    
    @State var photosAssets = PHFetchResultCollection(fetchResult: .init())
    
    // TODO: - Add fetch request for photos
    // TODO: - refactor as per photoGridFilteredView using fetch request
    

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
                            PhotoGridItemView(asset: asset)
                        }
                    }
                    .padding(10)
                }
            }
            .onAppear {
                let assetIdentifiers = photos.compactMap(\.assetIdentifier)
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
