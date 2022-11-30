//
//  BaseTestCase.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 25/11/2022.
//

import CoreData
import XCTest
@testable import Trip_Journal

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    var locationManager: LocationManager!
    
    var title1: String!
    var startDate1: Date!
    var endDate1: Date!
    
    var title2: String!
    var startDate2: Date!
    var endDate2: Date!
    
    var title3: String!
    var startDate3: Date!
    var endDate3: Date!

    @MainActor override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        title1 = "France"
        startDate1 = dateFormatter.date(from: "14/11/2022") ?? Date.now
        endDate1 = dateFormatter.date(from: "20/11/2022") ?? Date.now

        title2 = "Italy"
        startDate2 = dateFormatter.date(from: "23/11/2022") ?? Date.now
        endDate2 = dateFormatter.date(from: "24/11/2022") ?? Date.now
        
        title3 = "Spain"
        startDate3 = dateFormatter.date(from: "01/11/2022") ?? Date.now
        endDate3 = dateFormatter.date(from: "04/11/2022") ?? Date.now
        
        _ = Trip(context: dataController.container.viewContext, title: title1, startDate: startDate1, endDate: endDate1)
        _ = Trip(context: dataController.container.viewContext, title: title2, startDate: startDate2, endDate: endDate2)
        _ = Trip(context: dataController.container.viewContext, title: title3, startDate: startDate3, endDate: endDate3)
        dataController.save()
        locationManager = LocationManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
