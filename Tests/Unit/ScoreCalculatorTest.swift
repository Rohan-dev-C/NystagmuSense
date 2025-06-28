import XCTest
@testable import NystagmuSense

final class ScoreCalculatorTests: XCTestCase {
    func testScale() {
        let calc = ScoreCalculator()
        XCTAssertEqual(calc.score(fromShade: 1), 0, accuracy: 0.001)
        XCTAssertEqual(calc.score(fromShade: 100), 2, accuracy: 0.001)
    }
}
