//
//  PhotoAssetIdentifier-CoreDataHelpers.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import CoreData
import Foundation


extension Photo {
    
    convenience init(context: NSManagedObjectContext, assetIdentifier: String) {
        self.init(context: context)
        id = UUID()
        self.assetIdentifier = assetIdentifier
    }
    
    var photoAssetIdentifier: String {
        assetIdentifier ?? ""
    }
}
