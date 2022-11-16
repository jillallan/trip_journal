//
//  TimelineViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 15/11/2022.
//

import Foundation

class TimelineViewModel: ObservableObject {
    @Published var dateRange = CalendarRange(calendar: Calendar(identifier: .gregorian), component: .day, epoch: Date(), values: 0...3600)
    
//    let myRange = calendar.range(of: .day, in: .month, for: date!)
    
    // May not need this
    @Published var months = [Date]()
    
    init() {
        let now = Date()
        let valueRange = 1 ... 120
        let calendar = Calendar(identifier: .gregorian)
        let tempMonths = valueRange.map { int in
            calendar.date(byAdding: .day, value: int, to: now)!
        }
        _months = Published(initialValue: tempMonths)
    }
    
}
