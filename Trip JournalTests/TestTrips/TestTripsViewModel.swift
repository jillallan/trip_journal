//
//  TestTripsViewModel.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 24/11/2022.
//

import CoreData
import XCTest
@testable import Trip_Journal

final class TestTripsViewModel: BaseTestCase {
    var viewModel: TripsViewModel!
//    var title1: String!
//    var startDate1: Date!
//    var endDate1: Date!
//
//    var title2: String!
//    var startDate2: Date!
//    var endDate2: Date!
//
//    var title3: String!
//    var startDate3: Date!
//    var endDate3: Date!

    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        viewModel = TripsViewModel(dataController: dataController, locationManager: locationManager)
        
//        title1 = "France"
//        startDate1 = dateFormatter.date(from: "14/11/2022") ?? Date.now
//        endDate1 = dateFormatter.date(from: "20/11/2022") ?? Date.now
//
//        title2 = "Italy"
//        startDate2 = dateFormatter.date(from: "23/11/2022") ?? Date.now
//        endDate2 = dateFormatter.date(from: "24/11/2022") ?? Date.now
//
//        title3 = "Spain"
//        startDate3 = dateFormatter.date(from: "01/11/2022") ?? Date.now
//        endDate3 = dateFormatter.date(from: "04/11/2022") ?? Date.now
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testFetchTripsFetchesAllTrips() {
        let trips = viewModel.fetchTrips()
        
        XCTAssertTrue(trips.count == 3)
    }
    
    @MainActor func testFetchTripsFetchesTripsInDescendingOrder() {
//        let initialTrips: [Trip] = []
        
        let trips = viewModel.fetchTrips()
        
        if let trip1StartDateTimeInterval = trips[0].startDate?.timeIntervalSinceNow,
           let trip2StartDateTimeInterval = trips[1].startDate?.timeIntervalSinceNow,
           let trip3StartDateTimeInterval = trips[2].startDate?.timeIntervalSinceNow {
            
            XCTAssertGreaterThan(trip2StartDateTimeInterval, trip1StartDateTimeInterval)
            XCTAssertGreaterThan(trip3StartDateTimeInterval, trip2StartDateTimeInterval)
            XCTAssertGreaterThan(trip3StartDateTimeInterval, trip1StartDateTimeInterval)
        }
        
        
        
//        XCTAssertEqual(trips.count, initialTrips.count + 1)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
