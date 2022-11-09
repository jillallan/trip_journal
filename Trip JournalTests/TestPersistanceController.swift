//
//  TestPersistanceController.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 04/11/2022.
//

import XCTest
@testable import Trip_Journal

final class TestPersistanceController: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPersistanceControllerInitializesWithZeroSteps() throws {
        // Given

        // When
        let persistanceController = PersistanceController(inMemory: true)
        
        // Then
        XCTAssertEqual(persistanceController.steps.count, 0)
    }

//    func testPersistanceControllerInitializesSavesWithTwoSteps() throws {
//        // Given
//        let persistanceController = PersistanceController(inMemory: true)
//        let steps: [Step] = [
//            Step(latitude: 50, longitude: 0, timestamp: Date.now, name: "Step 1"),
//            Step(latitude: 51, longitude: 1, timestamp: Date.now, name: "Step 2")
//        ]
//
//        // When
//        persistanceController.steps = steps
//        persistanceController.save()
//        persistanceController
//
//        // Then
//        XCTAssertEqual(persistanceController.steps.count, 2)
//    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
