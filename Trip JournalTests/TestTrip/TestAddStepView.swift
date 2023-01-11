//
//  TestAddEntry.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 23/11/2022.
//

import CoreData
import CoreLocation
import MapKit
import XCTest
@testable import Trip_Journal

final class TestAddEntryView: BaseTestCase {
    var region: MKCoordinateRegion!

    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testAddEntryIcreasesEntriesDataModelByOne() throws {
//        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let initialEntryCount = try managedObjectContext.count(for: request)
//        let coordinate = CLLocationCoordinate2D(latitude: 51.6, longitude: 0.5)
//
//        viewModel.addEntry(for: coordinate, name: "Test Entry")
//
//        let entryCount = try managedObjectContext.count(for: request)
//        XCTAssertEqual(entryCount, initialEntryCount + 1)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
