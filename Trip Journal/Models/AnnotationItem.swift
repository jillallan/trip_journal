//
//  AnnotationItem.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import CoreLocation
import Foundation

struct AnnotationItem: Identifiable {
    let id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
