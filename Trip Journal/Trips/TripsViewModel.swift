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
    
    init(dataController: DataController, locationManager: LocationManager, isPreview: Bool = false) {
        self.dataController = dataController
        self.locationManager = locationManager
        
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
        
        if isPreview {
            trips = createSampleData()
        } else {
            do {
                try tripsController.performFetch()
                trips = tripsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch trips: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Update model methods
    
    func addTrip(title: String, startDate: Date, endDate: Date) {
        _ = Trip(context: dataController.container.viewContext, title: title, startDate: startDate, endDate: endDate)
        dataController.save()
        updateFetchRequest()
    }
    
    // MARK: - Update view methods
    
    func updateFetchRequest() {
        do {
            try tripsController.performFetch()
            trips = tripsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch trips: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Methods
    
    func enableLocationTracking() {
        // check date range
        locationManager.startLocationServices()
    }
    
    func getUsersDefaultLocale() {
        let locale = Locale.current
        print(locale.language.region?.identifier as Any)

    }
}

// MARK: - Xcode preview

extension TripsViewModel {
    func createSampleData() -> [Trip] {
        var trips = [Trip]()
        
        for tripCounter in 1...3 {
            let trip = Trip()
            trip.title = "Test Trip \(tripCounter)"
            trip.startDate = Date.now
            trip.endDate = Date(timeIntervalSinceNow: 86400)
            trip.steps = []

            for stepCounter in 1...5 {
                var steps = [Step]()

                let step = Step()
                step.latitude = Double.random(in: 51.0...52.0)
                step.longitude = -Double.random(in: 2...3)
                step.timestamp = Date.now
                step.name = "Step \(stepCounter)"

                steps.append(step)
//                trip.steps = Set(steps) as NSSet
            }
            trips.append(trip)
        }
        return trips
    }
    
    static var preview: TripsViewModel = {
        TripsViewModel(dataController: .preview, locationManager: .preview, isPreview: true)
    }()
}
