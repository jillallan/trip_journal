//
//  TripViewMapModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import CoreLocation
import Foundation
import MapKit

@MainActor class TripViewModel: ObservableObject {
    let persistanceController: PersistanceController
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.37095813260197, longitude: -2.5465420593568187),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var tripRoute = [MKPolyline]()
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    var title: String {
        "Trip"
    }
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        let step = Step(coordinate: coordinate, timestamp: Date.now, name: "New Step \(Date.now)")
        addOverlay(for: step)
        persistanceController.steps.append(step)
        persistanceController.save()
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
    func addOverlay(for step: Step) {
        let overlayCoordinates = [persistanceController.steps.last?.coordinate ?? step.coordinate, step.coordinate]
        let polyline = MKPolyline(coordinates: overlayCoordinates, count: overlayCoordinates.count)
        tripRoute.append(polyline)
    }
    
    func addStepOverlay(for coordinate: CLLocationCoordinate2D) {
        let overlayCoordinates = [persistanceController.steps.last?.coordinate ?? coordinate, coordinate]
        let polyline = MKPolyline(coordinates: overlayCoordinates, count: overlayCoordinates.count)
        tripRoute.append(polyline)
    }
    
    func setRegionToTripStart() {
        if let newRegion = persistanceController.steps.first?.region {
            region = newRegion
        } else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
}

extension TripViewModel {
    static var preview: TripViewModel {
        TripViewModel(persistanceController: .preview)
    }
}
