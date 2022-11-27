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
    var tripName: String!
    var startDate: Date!
    var endDate: Date!

    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        viewModel = TripsViewModel(dataController: dataController, locationManager: locationManager)
        
        tripName = "France"
        startDate = dateFormatter.date(from: "14/11/2022")
        endDate = dateFormatter.date(from: "20/11/2022")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    @MainActor func testAddTripIncreasesTripsArrayByOne() throws {
//        let tripsArrayLength = viewModel.trips.count                // Given
//        viewModel.addTrip(title: tripName, startDate: startDate, endDate: endDate)       // When
//        XCTAssertEqual(viewModel.trips.count, tripsArrayLength + 1) // Then
//    }
//    
//    @MainActor func testAddStepIcreasesTripsDataModelByOne() throws {
//        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
//        let initialTripCount = try managedObjectContext.count(for: request)
//        
//        viewModel.addTrip(title: tripName, startDate: startDate, endDate: endDate)
//        
//        let tripCount = try managedObjectContext.count(for: request)
//        XCTAssertEqual(tripCount, initialTripCount + 1)
//    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
