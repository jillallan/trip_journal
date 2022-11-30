//
//  PlacemarksListViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import CoreLocation
import Foundation
import MapKit

class PlacemarkListView: ObservableObject {
    @Published var placemarks = [CLPlacemark]()
    let dataController: DataController
    let locationManager: LocationManager
    
    init(dataController: DataController, locationManager: LocationManager) {
        self.dataController = dataController
        self.locationManager = locationManager
    }
    
    func fetchPlacemarks(for coordinate: CLLocationCoordinate2D) async -> [String] {
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        let placemarks = await locationManager.fetchPlacemarks(for: location)
        let placemarkHelper = PlacemarkHelper()
        
        if let placemark = placemarks.first {
            let address = placemarkHelper.createAddress(from: placemark)
            let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
            let mkMapItem = MKMapItem(placemark: mkPlacemark)
        }
        
        if let placemarkPostalAddress = placemarks.first?.postalAddress {
            let mkPlacemark = MKPlacemark(coordinate: coordinate, postalAddress: placemarkPostalAddress)
            let mkMapItem = MKMapItem(placemark: mkPlacemark)
        }
        return placemarkHelper.createPlaceList(from: placemarks)
    }
}
