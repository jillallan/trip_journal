//
//  TestFileManagerExtension.swift
//  Trip JournalTests
//
//  Created by Jill Allan on 04/11/2022.
//

import XCTest
@testable import Trip_Journal

final class TestFileManagerExtension: XCTestCase {


    func testDocumentsDirectoryIsUrl() throws {
        let documentsDirectory = FileManager.documentsDirectory
        XCTAssertTrue(documentsDirectory.isFileURL)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
