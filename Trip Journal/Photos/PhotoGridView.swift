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
    
    @State private var presentedPhotoIndex = [PHAsset]()
    @State private var navPath = NavigationPath()
    
    // https://stackoverflow.com/questions/65690484/enumerated-method-not-working-on-array
    
    var body: some View {
        NavigationStack(path: $presentedPhotoIndex) {
            
            // MARK: - View
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(Array(photosAssets.enumerated()), id: \.1) { index, asset in
                        NavigationLink(value: asset) {
                            Photo(asset: asset)
                                .photoGridItemStyle(aspectRatio: 1, cornerRadius: 0)
                        }
                    }
                }
            }
            
            // MARK: - Navigation
            .navigationDestination(for: PHAsset.self) { asset in
                Photo(asset: asset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    // left
                                    print("Drag left done")
                                    print(presentedPhotoIndex)
                                    print(navPath)
//                                    presentedPhotoIndex = [presentedPhotoIndex[0] - 1]
//                                    print(presentedPhotoIndex)
                                }
                                
                                if value.translation.width > 0 {
                                    // right
                                    print("Drag right done")
                                    print(presentedPhotoIndex)
                                    print(navPath)
//                                    presentedPhotoIndex = [presentedPhotoIndex[0] - 1]
//                                    print(presentedPhotoIndex)
                                }
                            }
                    )
            }
            .navigationTitle("Photos")
            
            // MARK: - View Updates
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
