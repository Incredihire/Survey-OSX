import XCTest
@testable import Survey

class MyFeatureTests: XCTestCase {

    func testExample() {
        // Arrange
        let expected = 5
        
        // Act
        let result = add(2, 3)
        
        // Assert
        XCTAssertEqual(expected, result, "The addition result should be \(expected).")
    }

    // Add more tests here
}
