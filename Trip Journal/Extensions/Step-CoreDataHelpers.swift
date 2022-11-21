//
//  Step.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import CoreData
import Foundation
import MapKit

extension Step {
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
    var stepTimestamp: Date {
        timestamp ?? Date.now
    }
    
    var stepName: String {
        name ?? "New Step"
    }
    
    convenience init(
        context: NSManagedObjectContext,
        latitude: Double,
        longitude: Double,
        timestamp: Date,
        name: String
    ) {
        self.init(context: context)
        id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.name = name
    }
    
    convenience init(
        context: NSManagedObjectContext,
        coordinate: CLLocationCoordinate2D,
        timestamp: Date,
        name: String
    ) {
        self.init(context: context, latitude: coordinate.latitude, longitude: coordinate.longitude, timestamp: timestamp, name: name)
    }
}

extension Step: MKAnnotation {
    public var title: String? { stepName }
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}

//extension Step {
//    static var stepPreview: Step = {
//        let dataController = DataController.preview
//        let managedObjectContext = dataController.container.viewContext
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yy"
//
//        let date = "14/11/2022"
//
//        let step = Step(
//            context: managedObjectContext,
//            latitude: 51.1,
//            longitude: 0.0,
//            timestamp: dateFormatter.date(from: "14/11/2022") ?? Date.now,
//            name: "Setting off")
//        step.trip = Trip.preview
//        return step
//    }()
//
//    static var stepsPreview: [Step] = {
//        let dataController = DataController.preview
//        let managedObjectContext = dataController.container.viewContext
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yy"
//
//        let date = "14/11/2022"
//
//        let step1 = Step(context: managedObjectContext, latitude: 51.1, longitude: 0.0,
//            timestamp: dateFormatter.date(from: "14/11/2022") ?? Date.now, name: "Setting off")
//        step1.trip = Trip.preview
//
//        let step2 = Step(context: managedObjectContext, latitude: 51.2, longitude: 0.1,
//            timestamp: dateFormatter.date(from: "15/11/2022") ?? Date.now, name: "Halfway there")
//        step2.trip = Trip.preview
//
//        let step3 = Step(context: managedObjectContext, latitude: 51.5, longitude: 0.1,
//            timestamp: dateFormatter.date(from: "16/11/2022") ?? Date.now, name: "Pit stop")
//        step1.trip = Trip.preview
//
//        let step4 = Step(context: managedObjectContext, latitude: 51.6, longitude: 0.4,
//            timestamp: dateFormatter.date(from: "17/11/2022") ?? Date.now, name: "Arrived")
//        step2.trip = Trip.preview
//
//        return [step1, step2]
//
//    }()
//}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && rhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == lhs.center && rhs.span == lhs.span
    }
}
