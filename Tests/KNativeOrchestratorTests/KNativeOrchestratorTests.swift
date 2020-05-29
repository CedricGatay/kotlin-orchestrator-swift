import XCTest
@testable import KNativeOrchestrator

final class KNativeOrchestratorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(KNativeOrchestrator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
