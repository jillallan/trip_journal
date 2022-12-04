//
//  PhotoAssetManager.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/12/2022.
//

import Foundation
import Photos

class PhotoAssetManager: ObservableObject {

    
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    func fetchAssets() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
//    func getAsset() -> PHAsset {
//        //
//    }
}
