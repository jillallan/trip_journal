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
import Contacts

@MainActor class TripViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    let trip: Trip
    let dataController: DataController
    let locationManager: LocationManager
    var title: String { "Trip" }
    var featureAnnotation: MKMapFeatureAnnotation!
    
    private let stepsController: NSFetchedResultsController<Step>
    @Published var steps = [Step]()
    @Published var tripRoute = [MKPolyline]()
    
    // replace with users current location or capital city of users locale
//    @Published var region = MKCoordinateRegion()
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
    
    // MARK: - Init
    
    init(trip: Trip, dataController: DataController, locationManager: LocationManager) {
        self.trip = trip
        self.dataController = dataController
        self.locationManager = locationManager
        
        
        let request: NSFetchRequest<Step> = Step.fetchRequest()
        request.predicate = NSPredicate(format: "trip.title = %@", trip.tripTitle)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)]
        
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
            
            let mapViewHelper = MapViewHelper(locationManager: locationManager)
            
            if !steps.isEmpty {
                tripRoute = mapViewHelper.createRoute(from: steps.map(\.coordinate))
                region = mapViewHelper.calculateMapRegion(from: steps)
            } else {
                region = mapViewHelper.calculateMapRegionWihLocale()
            }
            
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update model
    
    
    // MARK: - Update View
    
    func fetchSteps() -> [Step] {
        var steps: [Step] = []
        do {
            try stepsController.performFetch()
            steps = stepsController.fetchedObjects ?? []
            
            if !steps.isEmpty {
                let mapViewHelper = MapViewHelper(locationManager: locationManager)
                tripRoute = mapViewHelper.createRoute(from: steps.map(\.coordinate))
            }
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
        return steps
    }
    
    func getRegionForLastStep() -> MKCoordinateRegion {
        var region = MKCoordinateRegion()
        do {
            try stepsController.performFetch()
            if let centre = stepsController.fetchedObjects?.last?.coordinate {
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                region = MKCoordinateRegion(center: centre, span: span)
            }
        } catch {
            print("Failed to fetch last step: \(error.localizedDescription)")
        }
        return region
    }
    
    func deleteSteps(at offsets: IndexSet) {
        
        for offset in offsets {
            let step = steps[offset]
            dataController.delete(step)
        }
        dataController.save()
    }
}
