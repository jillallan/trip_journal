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
    var viewModel: TripViewModelOld!

    override func setUpWithError() throws {
        // Given
        mapRegionCoordinate = CLLocationCoordinate2D(latitude: 50, longitude: 0)
        viewModel = TripViewModelOld(persistanceController: PersistanceController())
        viewModel.region.center = mapRegionCoordinate
        
//        viewModel = TripViewModel(
//            region: MKCoordinateRegion(
//                center: mapRegionCoordinate, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//            )
//        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddStepForCoordinateIcreasesStepsArrayByOne() throws {
        // Given
        let stepsArrayLength = viewModel.persistanceController.steps.count
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        viewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(viewModel.persistanceController.steps.count, stepsArrayLength + 1)
    }
    
    func testAddStepAddsStepWithCoordinateEqualToMapRegion() throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        viewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(viewModel.persistanceController.steps.last?.coordinate, coordinate)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
