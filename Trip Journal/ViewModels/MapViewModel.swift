//
//  MapViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    @Published var steps = [Step]()
    @Published var region: MKCoordinateRegion
    
    init(region: MKCoordinateRegion) {
        self.region = region
    }
    
    func addStep() {
//        let step = Step(
//            latitude: region.center.latitude,
//            longitude: region.center.longitude,
//            timestamp: Date.now
//        )
        let step = Step(coordinate: region.center, timestamp: Date.now)
        steps.append(step)
    }
    
    func updateRegion() {
        // TODO: -
    }
}
