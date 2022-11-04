//
//  Trip_JournalTests.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 02/11/2022.
//

import MapKit
import XCTest
@testable import Trip_Journal

final class TestMapViewModel: XCTestCase {
    var mapRegionCoordinate: CLLocationCoordinate2D!
    var mapViewModel: MapViewModel!

    override func setUpWithError() throws {
        // Given
        mapRegionCoordinate = CLLocationCoordinate2D(latitude: 50, longitude: 0)
        mapViewModel = MapViewModel()
        mapViewModel.region.center = mapRegionCoordinate
        
//        mapViewModel = MapViewModel(
//            region: MKCoordinateRegion(
//                center: mapRegionCoordinate, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//            )
//        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddTestIcreasesStepsArrayByOne() throws {
        // Given
        let stepsArrayLength = mapViewModel.steps.count
        
        // When
        mapViewModel.addStep()
        
        // Then
        XCTAssertEqual(mapViewModel.steps.count, stepsArrayLength + 1)
    }
    
    func testAddTestForCoordinateIcreasesStepsArrayByOne() throws {
        // Given
        let stepsArrayLength = mapViewModel.steps.count
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        mapViewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(mapViewModel.steps.count, stepsArrayLength + 1)
    }
    
    func testAddTestAddsTestWithCoordinateEqualToMapRegion() throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 51, longitude: 5)
        
        // When
        mapViewModel.addStep(for: coordinate)
        
        // Then
        XCTAssertEqual(mapViewModel.steps.last?.coordinate, coordinate)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
