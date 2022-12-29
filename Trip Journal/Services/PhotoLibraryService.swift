//
//  PhotoAssetManager.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/12/2022.
//

import CoreData
import Foundation
import Photos
import UIKit
import SwiftUI

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
    
    func cacheAllAssets() {
        // TODO: -
        imageCachingManager.allowsCachingHighQualityImages = true
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        DispatchQueue.main.async {
            self.results.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        }
    }
    
    func cacheAllAssets2() {
        imageCachingManager.allowsCachingHighQualityImages = true
        
        let request: NSFetchRequest<PhotoAssetIdentifier> = PhotoAssetIdentifier.fetchRequest()
        do {
            let photoAssetIdentifiers = try dataController.container.viewContext.fetch(request)
            let identifierStrings = photoAssetIdentifiers.compactMap(\.assetIdentifier)
            let assetFetchRequest = PHAsset.fetchAssets(withLocalIdentifiers: identifierStrings, options: nil)
            var assets = [PHAsset]()
            assetFetchRequest.enumerateObjects { asset, _, _ in
                assets.append(asset)
//                print("cachedImage: \(assets.count)")
            }
            
            imageCachingManager.startCachingImages(for: assets, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: nil)
        } catch {
            print("Failed to fetch photo request: \(error.localizedDescription)")
        }
        
        
//        imageCachingManager.startCachingImage
        
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
    
    func fetchAssets(with photoAssetIdentifiers: FetchedResults<PhotoAssetIdentifier>) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let identifierStrings = photoAssetIdentifiers.compactMap(\.assetIdentifier)
        return PHAsset.fetchAssets(withLocalIdentifiers: identifierStrings, options: fetchOptions)
    }
}


extension PhotoLibraryService {
    static var preview: PhotoLibraryService = {
        PhotoLibraryService(dataController: .preview)
    }()
}
