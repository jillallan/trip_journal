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
    
    var trip1: Trip!
    var title1: String!
    var startDate1: Date!
    var endDate1: Date!
    
    var trip2: Trip!
    var title2: String!
    var startDate2: Date!
    var endDate2: Date!
    
    var trip3: Trip!
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
        
        trip1 = Trip(context: dataController.container.viewContext, title: title1, startDate: startDate1, endDate: endDate1)
        trip2 = Trip(context: dataController.container.viewContext, title: title2, startDate: startDate2, endDate: endDate2)
        trip3 = Trip(context: dataController.container.viewContext, title: title3, startDate: startDate3, endDate: endDate3)
        
        let step1 = Step(context: managedObjectContext, latitude: 51.441, longitude: -2.593,
                         timestamp: dateFormatter.date(from: "28/11/2022 09:00:00") ?? Date.now, name: "Bedminster Station")
        step1.trip = trip1
        let step2 = Step(context: managedObjectContext, latitude: 51.531, longitude: -0.126,
                         timestamp: dateFormatter.date(from: "28/11/2022 11:00:00") ?? Date.now, name: "St Pancras")
        step2.trip = trip1
        let step3 = Step(context: managedObjectContext, latitude: 50.895, longitude: 4.342,
                         timestamp: dateFormatter.date(from: "29/11/2022 10:00:00") ?? Date.now, name: "Atomium")
        step3.trip = trip2
        let step4 = Step(context: managedObjectContext, latitude: 50.954, longitude: 6.959,
                         timestamp: dateFormatter.date(from: "29/11/2022 18:00:00") ?? Date.now, name: "Cologne")
        step4.trip = trip3
        let step5 = Step(context: managedObjectContext, latitude: 55.749, longitude: 37.567,
                         timestamp: dateFormatter.date(from: "01/08/2022 11:00:00") ?? Date.now, name: "Moscow")
        step5.trip = trip3
        let step6 = Step(context: managedObjectContext, latitude: 55.850, longitude: 37.500,
                         timestamp: dateFormatter.date(from: "27/07/2022 11:30:00") ?? Date.now, name: "Moscow")
        step5.trip = trip3
        
        let trip1Steps = [step1, step2, step6]
        trip1.steps = Set(trip1Steps) as NSSet
        let trip2Steps = [step3]
        trip2.steps = Set(trip2Steps) as NSSet
        let trip3Steps = [step4, step5]
        trip3.steps = Set(trip3Steps) as NSSet
        
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
