//
//  AddTripViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import Foundation

class AddTripViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var title: String = ""
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var tripTrackingIsOn: Bool = false
    
    let dataController: DataController
    let locationManager: LocationManager
    
    // MARK: - Init
    
    init(dataController: DataController, locationManager: LocationManager) {
        self.dataController = dataController
        self.locationManager = locationManager
    }
    
    // MARK: - Update Model Methods
    
    func addTrip(title: String, startDate: Date, endDate: Date) {
        _ = Trip(context: dataController.container.viewContext, title: title, startDate: startDate, endDate: endDate)
        dataController.save()
    }
}
