//
//  TripsViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import Foundation
import CoreData

@MainActor class TripsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    // TODO: - Add countries published property??
    
    // MARK: - Properties
    
    @Published var trips = [Trip]()
    
    let dataController: DataController
    let locationManager: LocationManager
    private let tripsController: NSFetchedResultsController<Trip>
    
    var title: String { "Trips" }
    
    // MARK: - Init
    
    init(dataController: DataController, locationManager: LocationManager) {
        self.dataController = dataController
        self.locationManager = locationManager
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)]
        
        tripsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        tripsController.delegate = self
        
        
        do {
            try tripsController.performFetch()
            trips = tripsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch trips: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Update model
    
    func deleteTrips(at offsets: IndexSet) {
        // TODO: - Do we need sort order
        
        for offset in offsets {
            
            let trip = trips[offset]
            let steps = trip.tripSteps
            for step in steps {
                dataController.delete(step)
            }
            dataController.delete(trip)
        }
        dataController.save()
    }
    
    // MARK: - Update view methods
    
    func fetchTrips() -> [Trip] {
        var trips: [Trip] = []
        do {
            try tripsController.performFetch()
            trips = tripsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch trips: \(error.localizedDescription)")
        }
        return trips
    }
}
