//
//  Trip_JournalUITests.swift
//  Trip JournalUITests
//
//  Created by Jill Allan on 11/11/2022.
//

import XCTest

final class Trip_JournalUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
                
                

        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let testExpression = app.scrollViews["TripView"].exists
//        app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"United Kingdom").element/*[[".maps.containing(.other, identifier:\"Rouen\").element",".maps.containing(.other, identifier:\"Le Havre\").element",".maps.containing(.other, identifier:\"Cherbourg-en-Cotentin\").element",".maps.containing(.other, identifier:\"Amiens\").element",".maps.containing(.other, identifier:\"Dorset AONB\").element",".maps.containing(.other, identifier:\"Brighton\").element",".maps.containing(.other, identifier:\"Southampton\").element",".maps.containing(.other, identifier:\"Calais\").element",".maps.containing(.other, identifier:\"Guildford\").element",".maps.containing(.other, identifier:\"North Wessex Downs AONB\").element",".maps.containing(.other, identifier:\"London\").element",".maps.containing(.other, identifier:\"Cotswolds AONB\").element",".maps.containing(.other, identifier:\"Colchester\").element",".maps.containing(.other, identifier:\"Milton Keynes\").element",".maps.containing(.other, identifier:\"Northampton\").element",".maps.containing(.other, identifier:\"Birmingham\").element",".maps.containing(.other, identifier:\"Peterborough\").element",".maps.containing(.other, identifier:\"Norwich\").element",".maps.containing(.other, identifier:\"Leicester\").element",".maps.containing(.other, identifier:\"Nottingham\").element",".maps.containing(.other, identifier:\"Stoke-on-Trent\").element",".maps.containing(.other, identifier:\"Peak District National Park\").element",".maps.containing(.other, identifier:\"Sheffield\").element",".maps.containing(.other, identifier:\"Kingston upon Hull\").element",".maps.containing(.other, identifier:\"Bradford\").element",".maps.containing(.other, identifier:\"Leeds\").element",".maps.containing(.other, identifier:\"Forest of Bowland AONB\").element",".maps.containing(.other, identifier:\"United Kingdom\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,28],[-1,27],[-1,26],[-1,25],[-1,24],[-1,23],[-1,22],[-1,21],[-1,20],[-1,19],[-1,18],[-1,17],[-1,16],[-1,15],[-1,14],[-1,13],[-1,12],[-1,11],[-1,10],[-1,9],[-1,8],[-1,7],[-1,6],[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.swipeUp()
//        XCTAssertEqual(true, testExpression)
    }
    
    func testNewExample() throws {
        
        let app = XCUIApplication()
//        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Trip"]/*[[".cells.buttons[\"Trip\"]",".buttons[\"Trip\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let map = app.maps.element
        let testElement = app.buttons.element
        
//        XCTAssertEqual(map, testElement)
        
//        app.maps.element        
//        let vkpointfeatureMap = app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"London").element/*[[".maps.containing(.other, identifier:\"Rouen\").element",".maps.containing(.other, identifier:\"Le Havre\").element",".maps.containing(.other, identifier:\"Cherbourg-en-Cotentin\").element",".maps.containing(.other, identifier:\"Amiens\").element",".maps.containing(.other, identifier:\"Dorset AONB\").element",".maps.containing(.other, identifier:\"Brighton\").element",".maps.containing(.other, identifier:\"Southampton\").element",".maps.containing(.other, identifier:\"Calais\").element",".maps.containing(.other, identifier:\"Guildford\").element",".maps.containing(.other, identifier:\"North Wessex Downs AONB\").element",".maps.containing(.other, identifier:\"London\").element",".maps.containing(.other, identifier:\"Cotswolds AONB\").element",".maps.containing(.other, identifier:\"Colchester\").element",".maps.containing(.other, identifier:\"Milton Keynes\").element",".maps.containing(.other, identifier:\"Northampton\").element",".maps.containing(.other, identifier:\"Birmingham\").element",".maps.containing(.other, identifier:\"Peterborough\").element",".maps.containing(.other, identifier:\"Norwich\").element",".maps.containing(.other, identifier:\"Leicester\").element",".maps.containing(.other, identifier:\"Nottingham\").element",".maps.containing(.other, identifier:\"Stoke-on-Trent\").element",".maps.containing(.other, identifier:\"Peak District National Park\").element",".maps.containing(.other, identifier:\"Sheffield\").element",".maps.containing(.other, identifier:\"Kingston upon Hull\").element",".maps.containing(.other, identifier:\"Bradford\").element",".maps.containing(.other, identifier:\"Leeds\").element",".maps.containing(.other, identifier:\"Forest of Bowland AONB\").element",".maps.containing(.other, identifier:\"United Kingdom\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,28],[-1,27],[-1,26],[-1,25],[-1,24],[-1,23],[-1,22],[-1,21],[-1,20],[-1,19],[-1,18],[-1,17],[-1,16],[-1,15],[-1,14],[-1,13],[-1,12],[-1,11],[-1,10],[-1,9],[-1,8],[-1,7],[-1,6],[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[18]]@END_MENU_TOKEN@*/
//        vkpointfeatureMap.swipeUp()
//        app.navigationBars["Trip"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        

                        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
