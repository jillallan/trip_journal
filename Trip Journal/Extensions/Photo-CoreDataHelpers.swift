//
//  PhotoAssetIdentifier-CoreDataHelpers.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import CoreData
import Foundation
import Photos

extension PhotoAssetIdentifier {
    
    convenience init(context: NSManagedObjectContext, assetIdentifier: String) {
        self.init(context: context)
        id = UUID()
        self.assetIdentifier = assetIdentifier
    }
    
    var photoAssetIdentifier: String {
        assetIdentifier ?? ""
    }
}

//extension PhotoAssetIdentifier {
//    static var preview: PhotoAssetIdentifier = {
//        let dataController = DataController.preview
//        let viewContext = dataController.container.viewContext
//
//        var assets = [PHAsset]()
//        let assetFetchRequest = PHAsset.fetchAssets(with: .image, options: nil)
//        assetFetchRequest.enumerateObjects { asset, int, _ in
//
//            assets.append(asset)
//        }
//
//        let assetIdentifiers = assets.compactMap(\.localIdentifier)
//        return PhotoAssetIdentifier(context: viewContext, assetIdentifier: assets[0])
//
//
//    }()
    
//    static var preview: PhotoAssetIdentifier {
//        previews[0]
//    }
    
//    static var previews: [PhotoAssetIdentifier] = {
//        let dataController = DataController.preview
//        let viewContext = dataController.container.viewContext
//
//        let photoAssetIdentifiers = createSamplePhotoAssetIdentifiers(managedObjectContext: viewContext)
//
//        return photoAssetIdentifiers
//    }()
    
//    static func createSamplePhotoAssetIdentifiers(managedObjectContext: NSManagedObjectContext) -> [PhotoAssetIdentifier] {
//        var photoAssetIdentifiers = [PhotoAssetIdentifier]()
//        let photoAssetIdentifier = PhotoAssetIdentifier(context: managedObjectContext, assetIdentifier: "9F983DBA-EC35-42B8-8773-B597CF782EDD/L0/001")
//        photoAssetIdentifiers.append(photoAssetIdentifier)
//
//        return photoAssetIdentifiers
//    }
    
    
//}
