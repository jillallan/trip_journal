//
//  TestLocationManager.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 24/11/2022.
//

import CoreLocation
import XCTest
@testable import Trip_Journal

final class TestLocationManager: XCTestCase {
    var locationManager: LocationManager!

    override func setUpWithError() throws {
        // given
        locationManager = LocationManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocationManagerInitSetsADelegate() throws {
        // when
        let delegate = locationManager.locationManager.delegate
        
        // then
        XCTAssertNotNil(delegate)
    }
    
    func testLocationManagerStartLocationServicesStartsIfLocationServiceEnabled() throws {
        // given
//        locationManager.locationManager.authorizationStatus = .authorizedAlways
        
        // when
//        XCTAssertTrue(CLLocationManager.locationServicesEnabled())
        
        
        // then
        
    }
    
    func testFetchPlacemarksReturnsAnArray() async throws {
        // given
        let location = CLLocation(latitude: 51.5, longitude: 0.0)
    
        
        // when
        let placemarks = await locationManager.fetchPlacemarks(for: location)
        
        // then

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
