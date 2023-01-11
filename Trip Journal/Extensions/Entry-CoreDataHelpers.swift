//
//  Entry.swift
//  Trip Journal
//
//  Created by Jill Allan on 02/11/2022.
//

import CoreData
import Foundation
import MapKit

extension Entry {
    
    // MARK: - Init
    
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
    
    // MARK: - Properties View API
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
    var entryTimestamp: Date {
        timestamp ?? Date.now
    }
    
    var entryName: String {
        name ?? "New Entry"
    }
    
    var entryPhotoAssetIdentifiers: [PhotoAssetIdentifier] {
        photoAssetIdentifiers?.allObjects as? [PhotoAssetIdentifier] ?? []
    }
}

// MARK: - Extension MKAnnotation

extension Entry: MKAnnotation {
    public var title: String? { entryName }
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Extension Xcode Preview

extension Entry {
    
    static var preview: Entry {
        previews[0]
    }
    
    static var previews: [Entry] = {
        let dataController = DataController.preview
        let moc = dataController.container.viewContext
        return createSampleEntries(managedObjectContext: moc, trip: Trip.preview)
    }()
    
    static func createSampleEntries(managedObjectContext: NSManagedObjectContext, trip: Trip) -> [Entry] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
        
        let entry1 = Entry(context: managedObjectContext, latitude: 51.441, longitude: -2.593,
                         timestamp: dateFormatter.date(from: "28/11/2022 09:00:00") ?? Date.now, name: "Bedminster Station, just setting off")
        entry1.trip = trip
        
        let entry2 = Entry(context: managedObjectContext, latitude: 51.531, longitude: -0.126,
                         timestamp: dateFormatter.date(from: "28/11/2022 11:00:00") ?? Date.now, name: "St Pancras")
        entry2.trip = trip
        
        let entry3 = Entry(context: managedObjectContext, latitude: 50.895, longitude: 4.342,
                         timestamp: dateFormatter.date(from: "29/11/2022 10:00:00") ?? Date.now, name: "Atomium")
        entry3.trip = trip
        
        let entry4 = Entry(context: managedObjectContext, latitude: 50.954, longitude: 6.959,
                         timestamp: dateFormatter.date(from: "29/11/2022 18:00:00") ?? Date.now, name: "Cologne")
        entry4.trip = trip
        
        let entry5 = Entry(context: managedObjectContext, latitude: 55.749, longitude: 37.567,
                         timestamp: dateFormatter.date(from: "01/08/2022 11:00:00") ?? Date.now, name: "Moscow")
        entry5.trip = trip
        return [entry1, entry2, entry3, entry4, entry5]
    }
}

// MARK: - Extension Equatable

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
