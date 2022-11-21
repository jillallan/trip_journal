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
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    @Published var fetchedPlacemarks = [CLPlacemark]()
    
    lazy var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func getPlacemarks(for location: CLLocation) async -> String {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                return placemark.description
            } else {
                return "No description found"
            }
        } catch {
            fatalError("Error getting placemarks: \(error.localizedDescription)")
        }
    }
    
    // Add make an async function??
    func getPlacemak(for location: CLLocation) {
        // One lookup per user action
        // If the user is travelling wait till a significant distance has been travelled
        // Or significant amount of time e.g. a minute
        // Never use a lookup when the app is in the background
  
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                fatalError("Error getting placemarks \(error.localizedDescription)")
                // too many requests will cause a kCLErrorDomain
            }
            
            guard let placemarks = placemarks else { return } //error?
            DispatchQueue.main.async {
                self?.fetchedPlacemarks = placemarks
            }
        }
    }
    
    func createAddress(from placemark: CLPlacemark) -> String {
        if let streetNumber = placemark.subThoroughfare,
           let street = placemark.thoroughfare,
           let city = placemark.locality,
           let state = placemark.administrativeArea {
            return "\(streetNumber) \(street) \(city) \(state)"
        } else if let city = placemark.locality,
                  let state = placemark.administrativeArea {
            return "\(city) \(state)"
        } else {
            return "Unknown address"
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: -
//        print("\(String(describing: locations.first?.coordinate))")
        
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
}

extension LocationManager {
    static var preview: LocationManager = {
        LocationManager()
    }()
}
