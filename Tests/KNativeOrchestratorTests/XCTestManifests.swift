import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KNativeOrchestratorTests.allTests),
    ]
}
#endif
