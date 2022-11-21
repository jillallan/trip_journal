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
    let trip: Trip
    let dataController: DataController
    let locationManager: LocationManager
    var title: String { "Trip" }
    
    private let stepsController: NSFetchedResultsController<Step>
    @Published var steps = [Step]()
    @Published var tripRoute = [MKPolyline]()
    
    // replace with users current location
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.37095813260197, longitude: -2.5465420593568187),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    init(trip: Trip, dataController: DataController, locationManager: LocationManager) {
        self.trip = trip
        self.dataController = dataController
        self.locationManager = locationManager
        
        print(trip.tripTitle)
        let request: NSFetchRequest<Step> = Step.fetchRequest()
        request.predicate = NSPredicate(format: "trip.title = %@", trip.tripTitle)
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
                let routeRenderer = MapViewHelper()
                tripRoute = routeRenderer.createRoute(from: steps.map(\.coordinate))
                region = routeRenderer.calculateMapRegion(from: steps)
            }
            
        } catch {
            print("Failed to fetch steps: \(error.localizedDescription)")
        }
    }
    
    func fetchPlacemarks(for coordinate: CLLocationCoordinate2D) async -> [String] {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print("view model location: \(location)")
        let placemarks = await locationManager.getPlacemarks(for: location)
        print("view model placemarks: \(placemarks)")
        let placemarkHelper = PlacemarkHelper()
        
        return placemarkHelper.createPlaceList(from: placemarks)
    }

    func addStep(for coordinate: CLLocationCoordinate2D, name: String) {
//        print("Add step: \(getPlacemark(for: coordinate))")
        let step = Step(
            context: dataController.container.viewContext,
            coordinate: coordinate,
            timestamp: Date.now,
            name: name //"New Step" // getPlacemark(for: coordinate)
        )
        step.trip = trip
        dataController.save()
        updateFetchRequest()
    }
    
    func updateFetchRequest() {
        do {
            try stepsController.performFetch()
            steps = stepsController.fetchedObjects ?? []
            print("Step added - init \(steps.count)")
            
            if !steps.isEmpty {
                let routeRenderer = MapViewHelper()
                tripRoute = routeRenderer.createRoute(from: steps.map(\.coordinate))
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

extension TripViewModel {
    static var preview: TripViewModel = {
        let dataController = DataController.preview
        let managedObjectContext = dataController.container.viewContext
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let startDate = dateFormatter.date(from: "14/11/2022") ?? Date.now
        let endDate = dateFormatter.date(from: "20/11/2022") ?? Date.now
        
        let trip = Trip(context: managedObjectContext, title: "France", startDate: startDate, endDate: endDate)
        
        return TripViewModel(trip: trip, dataController: .preview, locationManager: .preview)
    }()
}
