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
    var viewModel: TripViewModel!
    var coordinate: CLLocationCoordinate2D!
    var stepName: String!
    var mapRegionCoordinate: CLLocationCoordinate2D!
    
    
    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        

        viewModel = TripViewModel(
            trip: trip1,
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
    
    @MainActor func testDeleteStepsReducesStepsDataModelByOne() throws {
        let indexSet = IndexSet(integer: 0)
        viewModel.deleteSteps(at: indexSet)
        
        let steps = viewModel.fetchSteps()
        
        XCTAssertEqual(steps.count, 2)
    }
    
    @MainActor func testFetchStepsFetchesAllStepsForTrip() {
        let steps = viewModel.fetchSteps()
        
        XCTAssertEqual(steps.count, 3)
    }
    
    @MainActor func testFetchTripsFetchesTripsInDescendingOrder() {
        let steps = viewModel.fetchSteps()
        
        if let step1StartDateTimeInterval = steps[0].timestamp?.timeIntervalSinceNow,
           let step2StartDateTimeInterval = steps[1].timestamp?.timeIntervalSinceNow,
           let step3StartDateTimeInterval = steps[2].timestamp?.timeIntervalSinceNow {
            
            XCTAssertGreaterThan(step3StartDateTimeInterval, step1StartDateTimeInterval)
            XCTAssertGreaterThan(step3StartDateTimeInterval, step2StartDateTimeInterval)
            XCTAssertGreaterThan(step2StartDateTimeInterval, step1StartDateTimeInterval)
        }
    }
    
    @MainActor func testGetRegionForLastStepSetsCoordinateToLastStepCoordinate() {
        let lastStep = viewModel.steps.last
        
        let region = viewModel.getRegionForLastStep()
        
        XCTAssertEqual(lastStep?.coordinate, region.center)
    }

    override func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
