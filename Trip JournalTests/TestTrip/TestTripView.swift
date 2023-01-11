//
//  Trip_JournalTests.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 02/11/2022.
//

import MapKit
import XCTest
@testable import Trip_Journal
import CoreData

final class TestTripView: BaseTestCase {
    var coordinate: CLLocationCoordinate2D!
    var entryName: String!
    var mapRegionCoordinate: CLLocationCoordinate2D!
    
    
    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        entryName = "New Entry"
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testDeleteEntriesReducesEntriesDataModelByOne() throws {
//        let indexSet = IndexSet(integer: 0)
//        viewModel.deleteEntries(at: indexSet)
//
//        let entries = viewModel.fetchEntries()
//
//        XCTAssertEqual(entries.count, 2)
    }
    
    @MainActor func testFetchEntriesFetchesAllEntriesForTrip() {
//        let entries = viewModel.fetchEntries()
//
//        XCTAssertEqual(entries.count, 3)
    }
    
    @MainActor func testFetchTripsFetchesTripsInDescendingOrder() {
//        let entries = viewModel.fetchEntries()
//
//        if let entry1StartDateTimeInterval = entries[0].timestamp?.timeIntervalSinceNow,
//           let entry2StartDateTimeInterval = entries[1].timestamp?.timeIntervalSinceNow,
//           let entry3StartDateTimeInterval = entries[2].timestamp?.timeIntervalSinceNow {
//
//            XCTAssertGreaterThan(entry3StartDateTimeInterval, entry1StartDateTimeInterval)
//            XCTAssertGreaterThan(entry3StartDateTimeInterval, entry2StartDateTimeInterval)
//            XCTAssertGreaterThan(entry2StartDateTimeInterval, entry1StartDateTimeInterval)
//        }
    }
    
    @MainActor func testGetRegionForLastEntrySetsCoordinateToLastEntryCoordinate() {
//        let lastEntry = viewModel.entries.last
//
//        let region = viewModel.getRegionForLastEntry()
//
//        XCTAssertEqual(lastEntry?.coordinate, region.center)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
