import XCTest
@testable import NystagmuSense

final class EyeMovementDetectorTests: XCTestCase {
    func testStdDevHeuristic() throws {
        let velocities: [Float] = [0,10,-10,9,-9,0]
        XCTAssertTrue(OKNAnalyzer.isOKNActive(velocities))
    }
}