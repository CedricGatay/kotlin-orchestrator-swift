import XCTest
@testable import KNativeOrchestrator

final class KNativeOrchestratorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(KNativeOrchestrator().text, "Hello, World!")
        let orchestrator = KBaseNativeOrchestrator<String, String>()
        let producer = StringProducer()
        let consumer = StringConsumer()
        let mainTask = MainTaskImpl()
        print("Will run tool in orchestrator...")
        let group = orchestrator.runTool(mainTask: mainTask.run,
                             inProvider: producer.makeString,
                             outConsumer: consumer.read)
        print("Tool running, will wait for its completion...")
        group.wait()
        print("Tool ended properly")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
