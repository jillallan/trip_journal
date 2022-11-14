//
//  LocationQuery.swift
//  Trip Journal
//
//  Created by Jill Allan on 11/11/2022.
//

import Combine
import Foundation
import MapKit

@MainActor final class LocationQuery: ObservableObject {
    @Published var searchQuery = ""
//    @Published private(set) var searchResults = [String]()
    @Published private(set) var searchResults = [MKMapItem]()
    
    private var subscriptions: Set<AnyCancellable> = []
    private let region: MKCoordinateRegion
    
    init(region: MKCoordinateRegion) {
        self.region = region

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
//                    self?.searchResults = response.mapItems.compactMap(\.name)
                }
            }
            .store(in: &subscriptions)
    }
}

extension LocationQuery {
    static var preview = LocationQuery(region: MKCoordinateRegion(center: Step.preview.region.center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
}
