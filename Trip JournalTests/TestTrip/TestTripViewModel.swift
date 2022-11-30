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

final class TestTripViewModel: BaseTestCase {
    var trip: Trip!
    var viewModel: TripViewModel!
    var coordinate: CLLocationCoordinate2D!
    var stepName: String!
    var mapRegionCoordinate: CLLocationCoordinate2D!
    
    
    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        trip = Trip(
            context: managedObjectContext, title: "Test Trip",
            startDate: dateFormatter.date(from: "14/11/2022") ?? Date.now,
            endDate: dateFormatter.date(from: "20/11/2022") ?? Date.now
        )
        viewModel = TripViewModel(
            trip: trip,
            dataController: dataController,
            locationManager: locationManager
        )
        
        coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        stepName = "New Step"
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testExample2() throws {
        
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
