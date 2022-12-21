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
    
    // MARK: - Properties
    
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
    
    var tripStepSorted: [Step] {
        tripSteps.sorted { first, second in
//            if first.stepTimestamp < second.stepTimestamp {
//                return true
//            } else if first.stepTimestamp > second.stepTimestamp {
//                return false
//            }
            return first.stepTimestamp < second.stepTimestamp
            
        }
        

    }
    
    var tripPhotosAssetIdentifiers: [PhotoAssetIdentifier] {
        photoAssetIdentifiers?.allObjects as? [PhotoAssetIdentifier] ?? []
    }
    
    var region: MKCoordinateRegion {
        let coordinates = tripSteps.map(\.coordinate)
        if let maxLatitude = coordinates.map(\.latitude).max(),
           let minLatitude = coordinates.map(\.latitude).min(),
           let maxLongitude = coordinates.map(\.longitude).max(),
           let minLongitude = coordinates.map(\.longitude).min() {
            let centre = calculateCentreCoordinate(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            let span = calculateCoordinateSpan(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            return MKCoordinateRegion(center: centre, span: span)
        } else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0),
                span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
            )
        }
    }
    
    private func calculateCentreCoordinate(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
    }
    
    private func calculateCoordinateSpan(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> MKCoordinateSpan {
        return MKCoordinateSpan(
            latitudeDelta: (maxLatitude - minLatitude) * 1.2,
            longitudeDelta: (maxLongitude - minLongitude) * 1.2
        )
    }
    
//    private func calculateMapRegionWihLocale() -> MKCoordinateRegion {
//        // TODO: - Hardcode coordinates for all 7 continents
//
//        let locale = Locale.current
//        var centre = CLLocationCoordinate2D()
//        let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
//        var region = MKCoordinateRegion()
//
//        if let regionCode = locale.language.region?.identifier {
//            locationManager.fetchPlacemark(for: regionCode)
//            if let coordinates = locationManager.fetchedPlacemark?.location?.coordinate {
//                centre = coordinates
//            } else {
//                centre = CLLocationCoordinate2D(latitude: 60.0, longitude: -5.5)
//            }
//        } else {
//            centre = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0)
//        }
//        region = MKCoordinateRegion(center: centre, span: span)
//        return region
//    }
}

// MARK: - Xcode Preview

extension Trip {
    static var preview: Trip = {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext
        
        let trip = createSampleTrip(managedObjectContext: viewContext)
        let steps = Step.createSampleSteps(managedObjectContext: viewContext, trip: trip)
        
        trip.steps = Set(steps) as NSSet
        
        return trip
    }()
    
    static func createSampleTrip(managedObjectContext: NSManagedObjectContext) -> Trip {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let startDate = "14/11/2022"
        let endDate = "20/11/2022"

        let trip = Trip(
            context: managedObjectContext,
            title: "Bedminster to Beijing, then Tibet",
            startDate: dateFormatter.date(from: startDate) ?? Date.now,
            endDate: dateFormatter.date(from: endDate) ?? Date.now
        )
        return trip
    }
}
