//
//  TripViewMapModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import CoreLocation
import Foundation
import MapKit
import CoreData

@MainActor class TripViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    let dataController: DataController
    
    private let stepsController: NSFetchedResultsController<Step>
    @Published var steps = [Step]()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.37095813260197, longitude: -2.5465420593568187),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @Published var tripRoute = [MKPolyline]()
    
    init(dataController: DataController) {
        self.dataController = dataController
        
        let request: NSFetchRequest<Step> = Step.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Step.timestamp, ascending: false)]
        
        stepsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        stepsController.delegate = self
        
        do {
            try stepsController.performFetch()
            steps = stepsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
    }
    
    var title: String {
        "Trip"
    }
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        let step = Step(
            context: dataController.container.viewContext,
            coordinate: coordinate,
            timestamp: Date.now,
            name: "New Step \(Date.now)"
        )
        addOverlay(for: step)
        steps.append(step)
        dataController.save()
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
    func addOverlay(for step: Step) {
        let overlayCoordinates = [steps.last?.coordinate ?? step.coordinate, step.coordinate]
        let polyline = MKPolyline(coordinates: overlayCoordinates, count: overlayCoordinates.count)
        tripRoute.append(polyline)
    }
    
    func addStepOverlay(for coordinate: CLLocationCoordinate2D) {
        let overlayCoordinates = [steps.last?.coordinate ?? coordinate, coordinate]
        let polyline = MKPolyline(coordinates: overlayCoordinates, count: overlayCoordinates.count)
        tripRoute.append(polyline)
    }
    
    func setRegionToTripStart() {
        if let newRegion = steps.first?.region {
            region = newRegion
        } else {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
}

//extension TripViewModel {
//    static var preview: TripViewModel {
//        TripViewModel(persistanceController: .preview)
//    }
//}
