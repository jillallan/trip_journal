//
//  AddTripViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import Foundation

class AddTripViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var tripTrackingIsOn: Bool = false
}
