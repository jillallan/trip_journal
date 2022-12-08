//
//  PhotoAssetIdentifier-CoreDataHelpers.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import CoreData
import Foundation


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

extension PhotoAssetIdentifier {
    static var preview: PhotoAssetIdentifier = {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        return PhotoAssetIdentifier(context: viewContext, assetIdentifier: "9F983DBA-EC35-42B8-8773-B597CF782EDD/L0/001")
    }()
}
