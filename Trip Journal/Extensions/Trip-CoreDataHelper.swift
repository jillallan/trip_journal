//
//  Trip.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import CoreData
import Foundation
import MapKit

extension Trip {
    convenience init(context: NSManagedObjectContext, title: String, startDate: Date, endDate: Date) {
        self.init(context: context)
        id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var tripTitle: String {
        title ?? "New Trip"
    }
    
    var tripStartDate: Date {
        startDate ?? Date.now
    }
    
    var tripEndDate: Date {
        endDate ?? Date.now
    }
    
    var tripSteps: [Step] {
        steps?.allObjects as? [Step] ?? []
    }
    
    var centreCoordinate: CLLocationCoordinate2D {
        if !tripSteps.isEmpty {
            return CLLocationCoordinate2D(
                latitude: tripSteps.map(\.latitude).reduce(0, +) / Double(tripSteps.count),
                longitude: tripSteps.map(\.latitude).reduce(0, +) / Double(tripSteps.count)
            )
        } else {
            return CLLocationCoordinate2D(latitude: 51.5, longitude: 0)
        }
    }
    
    var coordinateSpan: MKCoordinateSpan {
        if let maxLatitude = tripSteps.map(\.latitude).max(),
           let minLatitude = tripSteps.map(\.latitude).max(),
           let maxLongitude = tripSteps.map(\.longitude).max(),
           let minLongitude = tripSteps.map(\.longitude).max() {
            return MKCoordinateSpan(
                latitudeDelta: maxLatitude - minLatitude,
                longitudeDelta: maxLongitude - minLongitude)
        } else {
            return MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        }
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: centreCoordinate, span: coordinateSpan)
    }
}
