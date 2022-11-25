//
//  LocationQuery.swift
//  Trip Journal
//
//  Created by Jill Allan on 11/11/2022.
//

import Combine
import Contacts
import CoreLocation
import Foundation
import MapKit

@MainActor final class LocationQuery: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchQuery = ""
    @Published private(set) var searchResults = [MKMapItem]()
    
    private var subscriptions: Set<AnyCancellable> = []
    private let region: MKCoordinateRegion
    
    // MARK: - Init
    
    init(region: MKCoordinateRegion, isPreview: Bool = false) {
        self.region = region
        
        if isPreview {
            searchResults = createSampleResults()
        } else {
            $searchQuery
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    let searchRequest = MKLocalSearch.Request()
                    searchRequest.naturalLanguageQuery = value
                    searchRequest.region = region
                    let search = MKLocalSearch(request: searchRequest)
                    search.start { response, error in
                        guard let response = response else {
                            if let error = error {
                                print("Error getting search \(error.localizedDescription)")
                            }
                            return
                        }
                        self?.searchResults = response.mapItems
                    }
                }
                .store(in: &subscriptions)
        }
    }
}

extension LocationQuery {
    func createSampleResults() -> [MKMapItem] {
        
        // TODO: - Add more items to array
        
        let address = [
            CNPostalAddressStreetKey: "Royal Observatory, Blackheath Avenue",
            CNPostalAddressCityKey: "London",
            CNPostalAddressPostalCodeKey: "SE10 8XJ",
            CNPostalAddressISOCountryCodeKey: "GB"
        ]
        
        let placemark = MKPlacemark(
            coordinate: CLLocationCoordinate2DMake(51.476833, 0.0),
            addressDictionary: address
        )
        
        return [MKMapItem(placemark: placemark)]
    }
    
    static var preview = LocationQuery(
        region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.476833, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        ),
        isPreview: true
    )
}
