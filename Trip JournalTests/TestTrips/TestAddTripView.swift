//
//  TestAddTripViewModel.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 25/11/2022.
//

import CoreData
import XCTest
@testable import Trip_Journal

final class TestAddTripView: BaseTestCase {

    var tripName: String!
    var startDate: Date!
    var endDate: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        
        tripName = "France"
        startDate = dateFormatter.date(from: "14/11/2022")
        endDate = dateFormatter.date(from: "20/11/2022")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    @MainActor func testAddEntryIcreasesTripsDataModelByOne() throws {
//        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
//        let initialTripCount = try managedObjectContext.count(for: request)
//
//        let tripView =
//
//        viewModel.addTrip(title: tripName, startDate: startDate, endDate: endDate)
//
//        let tripCount = try managedObjectContext.count(for: request)
//        XCTAssertEqual(tripCount, initialTripCount + 1)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
