import XCTest

final class NystagmuSenseUITests: XCTestCase {
    func testMenuButtonsExist() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Past Tests"].exists)
        XCTAssertTrue(app.buttons["Start Test"].exists)
    }
}
