//
//  SurveyUITests.swift
//  SurveyUITests
//
//  Created by Daryna Borzovets on 9/17/24.
//

import XCTest

final class SurveyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Setup code here. This method is called before each test method in the class.
        continueAfterFailure = false
        // Set initial state required for tests here.
    }

    override func tearDownWithError() throws {
        // Teardown code here. This method is called after each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
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

