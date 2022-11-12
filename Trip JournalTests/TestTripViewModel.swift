//
//  Trip_JournalTests.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 02/11/2022.
//

import MapKit
import XCTest
@testable import Trip_Journal

final class TestTripViewModel: XCTestCase {
    var mapRegionCoordinate: CLLocationCoordinate2D!
    var viewModel: TripViewModel!

    @MainActor override func setUpWithError() throws {
        // Given
        viewModel = TripViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func testAddStepForCoordinateIcreasesStepsArrayByOne() throws {
        // Given
        let stepsArrayLength = viewModel.steps.count
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        viewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(viewModel.steps.count, stepsArrayLength + 1)
    }
    
    @MainActor func testAddStepAddsStepWithCoordinateEqualToMapRegion() throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        viewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(viewModel.steps.last?.coordinate, coordinate)
    }
    
    @MainActor func testSetRegionSetsCoordinateRegionOnViewModel() throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // When
        viewModel.setRegion(for: coordinate)
        
        // Then
        XCTAssertEqual(viewModel.region.center, coordinate)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
