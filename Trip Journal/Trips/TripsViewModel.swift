//
//  TripsViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import Foundation
import CoreData

@MainActor class TripsViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    let dataController: DataController
//    @Published var countriesOrStates = [Country]()
    
    private let tripsController: NSFetchedResultsController<Trip>
    @Published var trips = [Trip]()
    
    var title: String { "Trips" }
    
    init(dataController: DataController) {
        self.dataController = dataController
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)]
        
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
    
    func addTrip(title: String, startDate: Date, endDate: Date) {
        _ = Trip(context: dataController.container.viewContext, title: title, startDate: startDate, endDate: endDate)
        dataController.save()
    }
    
    func updateFetchRequest() {
        do {
            try tripsController.performFetch()
            trips = tripsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch trips: \(error.localizedDescription)")
        }
    }
}
