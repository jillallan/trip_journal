//
//  LocationManager.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/11/2022.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var fetchedPlacemarks = [CLPlacemark]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var fetchedPlacemark: CLPlacemark?
    
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Methods
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
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
            locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: -
//        print("\(String(describing: locations.first?.coordinate))")
        
    }
}

// MARK: - Xcode previews

extension LocationManager {
    static var preview: LocationManager = {
        LocationManager()
    }()
}
