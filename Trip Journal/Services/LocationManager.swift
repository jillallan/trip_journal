//
//  LocationManager.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/11/2022.
//

import Foundation
import CoreLocation
import MapKit
import CoreData

class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var fetchedPlacemarks = [CLPlacemark]()
    
    var dataController: DataController
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var previousLocation: CLLocation?
    var currentVisit: CLVisit?
    var previousVisit: CLVisit?
    var fetchedPlacemark: CLPlacemark?
    
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Init
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 20.0
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
//        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Methods
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
            locationManager.startMonitoringVisits()
            locationManager.startMonitoringSignificantLocationChanges()
            addLog(at: Date.now, detail: "Start location services")
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func getCurrentLocation() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
            addLog(at: Date.now, detail: "Start location services")
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // One lookup per user action
    // If the user is travelling wait till a significant distance has been travelled
    // Or significant amount of time e.g. a minute
    // Never use a lookup when the app is in the background
    
    func fetchPlacemarks(for location: CLLocation) async -> [CLPlacemark] {
        var fetchedPlacemarksLocal = [CLPlacemark]()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            fetchedPlacemarksLocal = placemarks
        } catch {
            fatalError("Error getting placemarks: \(error.localizedDescription)")
            // too many requests will cause a kCLErrorDomain
        }
        return fetchedPlacemarksLocal
    }
    
    func fetchPlacemarks(for address: String) async -> [CLPlacemark] {
        var localFetchedPlacemarks = [CLPlacemark]()
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            localFetchedPlacemarks = placemarks
        } catch {
            fatalError("Error getting placemarks: \(error.localizedDescription)")
        }
        return localFetchedPlacemarks
    }
    
    func fetchPlacemark(for address: String) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.fetchedPlacemark = placemark
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
 
    // MARK: - Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startMonitoringVisits()
            addLog(at: Date.now, detail: "Start location services after authorisation change")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Access denied")
        default:
            print("Catch all errors")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        addLog(at: Date.now, detail: "Visit at Lat: \(visit.coordinate.latitude), Lon: \(visit.coordinate.longitude)")
        
        addVisit(for: visit)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: -
        if locations.count > 1 {
            addLog(at: Date.now, detail: "Location Count: \(locations.count)")
        }

        for location in locations {
            print(location)
            if let tempPreviousLocation = previousLocation,
               let tempCurrentLocation = currentLocation {
                let distance = location.distance(from: tempPreviousLocation)
                let time = location.timestamp.timeIntervalSince1970 - tempPreviousLocation.timestamp.timeIntervalSince1970
                let calculatedSpeed = distance / time
                print(location)
                addLocation(for: location, distance: distance, calculatedSpeed: calculatedSpeed)
                previousLocation = tempCurrentLocation
                currentLocation = location
            } else {
                if let tempCurrentLocation = currentLocation {
                    previousLocation = tempCurrentLocation
                    currentLocation = location
                } else {
                    currentLocation = location
                }
            }
        }
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        addLog(at: Date.now, detail: "Location Manager Did Resume Updates")
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        addLog(at: Date.now, detail: "Location Manager Did Pause Updates")
        if let lastUpdatedRegion = currentLocation?.coordinate {
            monitorRegionAtLocation(center: lastUpdatedRegion, identifier: "Last Location \(lastUpdatedRegion.latitude) \(lastUpdatedRegion.longitude)")
            addLog(at: Date.now, detail: "start monitoring region: \(lastUpdatedRegion.latitude) \(lastUpdatedRegion.longitude)")
        }
        
    }
    
    
    func addLocation(for location: CLLocation, distance: Double, calculatedSpeed: Double) {
        _ = Location(context: dataController.container.viewContext, cLlocation: location, distance: distance, calculatedSpeed: calculatedSpeed)

        dataController.save()
    }
    
    func addLog(at timestamp: Date, detail: String) {
        _ = EventLog(context: dataController.container.viewContext, timestamp: timestamp, detail: detail)
        
        dataController.save()
    }
    
    func addVisit(for visit: CLVisit) {
        _ = Visit(context: dataController.container.viewContext, visit: visit)
        
        dataController.save()
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = 50.0
            let region = CLCircularRegion(center: center,
                 radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = false
            region.notifyOnExit = true
       
            locationManager.startMonitoring(for: region)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            startLocationServices()
            addLog(at: Date.now, detail: "Exit region and start location services \(identifier)")
        }
    }
    
}

// MARK: - Xcode previews

extension LocationManager {
    static var preview: LocationManager = {
        LocationManager(dataController: .preview)
    }()
}
