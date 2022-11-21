//
//  Array-RemoveDuplicates.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/11/2022.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter { key in
            addedDict.updateValue(true, forKey: key) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
