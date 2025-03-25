
import XCTest

final class WalmartProjectPierreUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSearchBar() {
        let searchBar = app.searchFields["Search by name or capital"]
        searchBar.tap()
        searchBar.typeText("India")
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertFalse(firstCell.staticTexts["India"].exists)
        app.buttons["Clear text"].tap()
        XCTAssertTrue(app.tables.cells.count > 0)
    }
    
    func testNoResultsFound() {
        let searchBar = app.searchFields["Search by name or capital"]
        searchBar.tap()
        searchBar.typeText("NonExistentCountry")
        let footer = app.tables.staticTexts["No countries found"]
        XCTAssertTrue(footer.exists)
    }
    
    func testTableViewScroll() {
        let tableView = app.tables.firstMatch
        tableView.swipeUp()
        let lastCell = tableView.cells.element(boundBy: 9)
        XCTAssertTrue(lastCell.exists)
    }
}

