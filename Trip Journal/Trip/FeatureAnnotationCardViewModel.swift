//
//  FeatureAnnotationCardViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import Foundation
import MapKit

class FeatureAnnotationCardViewModel: ObservableObject {
    @Published var featureAnnotation: MKMapFeatureAnnotation
    @Published var mapItem = MKMapItem()
    
    init(featureAnnotation: MKMapFeatureAnnotation) {
        self.featureAnnotation = featureAnnotation

    }
}
