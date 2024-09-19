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
        let app = XCUIApplication()
        app.launch()
        // Add assertions here
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
