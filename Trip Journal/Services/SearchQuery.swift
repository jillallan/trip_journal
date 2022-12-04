//
//  SearchQuery.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/12/2022.
//

import Combine
import Foundation
import MapKit

final class SearchQuery: ObservableObject {
    @Published var searchQuery = ""
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
                }
            }
            .store(in: &subscriptions)
    }
}
