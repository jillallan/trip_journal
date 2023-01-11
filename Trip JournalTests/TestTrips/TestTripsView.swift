//
//  TestTripsViewModel.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 24/11/2022.
//

import CoreData
import XCTest
@testable import Trip_Journal

final class TestTripsView: BaseTestCase {

    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testFetchTripsFetchesAllTrips() {

    }
    
    @MainActor func testFetchTripsFetchesTripsInDescendingOrder() {
//        let trips = viewModel.fetchTrips()
//
//        if let trip1StartDateTimeInterval = trips[0].startDate?.timeIntervalSinceNow,
//           let trip2StartDateTimeInterval = trips[1].startDate?.timeIntervalSinceNow,
//           let trip3StartDateTimeInterval = trips[2].startDate?.timeIntervalSinceNow {
//
//            XCTAssertGreaterThan(trip1StartDateTimeInterval, trip2StartDateTimeInterval)
//            XCTAssertGreaterThan(trip2StartDateTimeInterval, trip3StartDateTimeInterval)
//            XCTAssertGreaterThan(trip1StartDateTimeInterval, trip3StartDateTimeInterval)
//        }
    }
    
    @MainActor func testDeleteTripsReducesTripsDataModelByOne() {
//        let indexSet = IndexSet(integer: 0)
//        viewModel.deleteTrips(at: indexSet)
//
//        let trips = viewModel.fetchTrips()
//
//        XCTAssertEqual(trips.count, 2)
    }
    
    @MainActor func testDeleteTripsReducesEntriesDataModelByNumberOfEntries() {
//        let indexSet = IndexSet(integer: 0)
//        let trip = viewModel.fetchTrips()[0]
//        
//        let tripViewModel = TripViewModel(trip: trip, dataController: dataController, locationManager: locationManager)
//        
//        viewModel.deleteTrips(at: indexSet)
//        
//        let entries = tripViewModel.fetchEntries()
//        
//        XCTAssertEqual(entries.count, 0)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
