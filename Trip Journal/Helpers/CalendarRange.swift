//
//  CalendarRange.swift
//  Trip Journal
//
//  Created by Jill Allan on 15/11/2022.
//

import Foundation

struct CalendarRange {
    let calendar: Calendar
    let component: Calendar.Component
    let epoch: Date
    let values: ClosedRange<Int>
}

extension CalendarRange: Collection {
    typealias Index = ClosedRange<Int>.Index
    
    var startIndex: Index { self.values.startIndex }
    var endIndex: Index { self.values.endIndex }
    
    func index(after i: Index) -> Index {
        self.values.index(after: i)
    }
    
    subscript(position: Index) -> Date {
        self.calendar.date(
            byAdding: self.component,
            value: self.values[position],
            to: self.epoch
        )! // ?? Date()
    }
}

extension CalendarRange: BidirectionalCollection {
    func index(before i: Index) -> Index {
        self.values.index(before: i)
    }
}

extension CalendarRange: RandomAccessCollection {
    
}

extension CalendarRange {
    var count: Int { self.values.count }
}

// https://juripakaste.fi/swift-date-ranges/
