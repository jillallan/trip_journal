//
//  AddStepViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class AddStepViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var region: MKCoordinateRegion
    @Published var searchQuery = ""
    @Published private(set) var searchResults = [MKMapItem]()
    
    let trip: Trip
    let dataController: DataController
    var searchResult: MKMapItem?
    var featureAnnotation: MKMapFeatureAnnotation?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(region: MKCoordinateRegion, trip: Trip, dataController: DataController) {
        self.region = region
        self.trip = trip
        self.dataController = dataController
        
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
    
    // MARK: - Update Model Methods
    
    
    func addStep(for coordinate: CLLocationCoordinate2D, name: String) {
        let step = Step(
            context: dataController.container.viewContext,
            coordinate: coordinate,
            timestamp: Date.now,
            name: name
        )
        step.trip = trip
        dataController.save()
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        print("will set region \(region.center)")
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        print("did set region \(region.center)")
    }
}
