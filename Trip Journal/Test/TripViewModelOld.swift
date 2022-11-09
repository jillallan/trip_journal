//
//  TripViewModelTest.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/11/2022.
//

import CoreLocation
import Foundation
import MapKit

class TripViewModelOld: ObservableObject {
    let persistanceController: PersistanceController
    @Published var steps = [Step]()
    @Published var region: MKCoordinateRegion


    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
        steps = persistanceController.steps
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        if let stepRegion = steps.first?.region {
            region = stepRegion
        }
    }
    
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        let step = Step(coordinate: coordinate, timestamp: Date.now, name: "New Step \(Date.now)")
        steps.append(step)
        persistanceController.steps = steps
        persistanceController.save()
    }
    
    func setRegion() {
        if let newRegion = steps.last?.region {
            region = newRegion
        } else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 47, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
}


