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
    
    var title: String { "Trip" }
    
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
            
            if !steps.isEmpty {
                let routeRenderer = RouteRenderer(coordinates: steps.map(\.coordinate))
                tripRoute = routeRenderer.createRoute()
            }
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
    }
    
    func addStep(for coordinate: CLLocationCoordinate2D) {
        _ = Step(
            context: dataController.container.viewContext,
            coordinate: coordinate,
            timestamp: Date.now,
            name: "New Step \(Date.now)"
        )
        dataController.save()
        updateFetchRequest()
    }
    
    func updateFetchRequest() {
        do {
            try stepsController.performFetch()
            steps = stepsController.fetchedObjects ?? []
            print("Step added - init \(steps.count)")
            
            if !steps.isEmpty {
                let routeRenderer = RouteRenderer(coordinates: steps.map(\.coordinate))
                tripRoute = routeRenderer.createRoute()
            }
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
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
