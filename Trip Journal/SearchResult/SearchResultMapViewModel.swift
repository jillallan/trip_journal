//
//  SearchResultsMapViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 26/11/2022.
//

import Foundation
import MapKit

struct SearchResultMapViewModel {
    let result: MKMapItem
    let region: MKCoordinateRegion
    let annotationItems: [AnnotationItem]
}
