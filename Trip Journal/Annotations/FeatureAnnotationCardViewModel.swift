//
//  FeatureAnnotationCardViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import Foundation
import MapKit

class FeatureAnnotationCardViewModel: ObservableObject {
    
    var featureAnnotation: MKMapFeatureAnnotation
    @Published var mapItem: MKMapItem?
    var addStep: ((MKMapItem?) -> Void)?
    
    init(featureAnnotation: MKMapFeatureAnnotation, addStep: ((MKMapItem?) -> Void)?) {
        self.featureAnnotation = featureAnnotation
        self.addStep = addStep
    }
    
    func getMapItem(with annotation: MKMapFeatureAnnotation) async -> MKMapItem {
        let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
        
        do {
            let featureItem = try await featureRequest.mapItem
            return featureItem
        } catch {
            fatalError("Failed to get map item: \(error.localizedDescription)")
        }
    }
}
