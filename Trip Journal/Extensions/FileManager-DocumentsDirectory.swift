//
//  FileManager-DocumentsDirectory.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import Foundation

extension FileManager {
    static var documentsDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
