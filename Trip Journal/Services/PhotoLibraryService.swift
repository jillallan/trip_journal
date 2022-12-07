//
//  PhotoAssetManager.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/12/2022.
//

import Foundation
import Photos
import UIKit

struct PHFetchResultCollection: RandomAccessCollection, Equatable {

    typealias Element = PHAsset
    typealias Index = Int

    var fetchResult: PHFetchResult<PHAsset>

    var endIndex: Int { fetchResult.count }
    var startIndex: Int { 0 }

    subscript(position: Int) -> PHAsset {
        fetchResult.object(at: fetchResult.count - position - 1)
    }
}

// TODO: - Add main actor
class PhotoLibraryService: ObservableObject {
    
    @Published var results = PHFetchResultCollection(fetchResult: .init())
    var imageCachingManager = PHCachingImageManager()
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }

    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    func fetchAllAssets() {
        // TODO: -
        imageCachingManager.allowsCachingHighQualityImages = false
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        DispatchQueue.main.async {
            self.results.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        }
    }
    
//    func fetchImage(with photoIdentifier: String) async throws -> UIImage? {
//        let results = PHAsset.fetchAssets(withLocalIdentifiers: [photoIdentifier], options: nil)
//        
//        guard let asset = results.firstObject else { return nil }
//        
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .opportunistic
//        options.resizeMode = .fast
//        options.isNetworkAccessAllowed = true
//        options.isSynchronous = true
//    }
    
    func fetchAssets() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    func fetchAssets(with identifiers: [Photo]) -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        let identifierStrings = identifiers.compactMap(\.assetIdentifier)
        return PHAsset.fetchAssets(withLocalIdentifiers: identifierStrings, options: allPhotosOptions)
    }
    
    func fetchAssets(with identifiers: [String]) -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
//        let identifierStrings = identifiers.compactMap(\.assetIdentifier)
        return PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: allPhotosOptions)
    }
    
}


extension PhotoLibraryService {
    static var preview: PhotoLibraryService = {
        PhotoLibraryService(dataController: .preview)
    }()
}
