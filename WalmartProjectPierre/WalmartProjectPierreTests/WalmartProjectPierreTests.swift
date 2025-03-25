import XCTest
@testable import WalmartProjectPierre

class WalmartProjectPierreTests: XCTestCase {
    var viewController: ViewController!
    var mockViewModel: CountryViewModel!
    var mockTableView: UITableView!
    
    override func setUp() {
        super.setUp()
        mockViewModel = CountryViewModel()
        viewController = ViewController()
        viewController.viewModel = mockViewModel
        
        mockTableView = UITableView()
        viewController.countryTableView = mockTableView
        self.viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockTableView = nil
        super.tearDown()
    }
    
    func testViewModelBinding() {
        let countryUSA = CountryModel(name: "USA", region: "NA", capital: "Washington", code: "USA", currency: nil, flag: nil, language: nil)
        let countryCanada = CountryModel(name: "Canada", region: "NA", capital: "Ottawa", code: "CA", currency: nil, flag: nil, language: nil)
        let countries = [countryUSA, countryCanada]
        let expectation = self.expectation(description: "reloadData should be called")
        mockViewModel.reloadData = {
            expectation.fulfill()
        }
        
        mockViewModel.countries = countries
        viewController.countries = countries
        viewController.filteredCountries = countries
        mockViewModel.reloadData?()
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewController.countries.count, 2, "ViewController should have 2 countries")
        XCTAssertEqual(viewController.filteredCountries.count, 2, "ViewController filteredCountries should have 2 countries")
    }
    
    func testFilterCountries() {
        let countryUSA = CountryModel(name: "USA", region: "NA", capital: "Washington", code: "USA", currency: nil, flag: nil, language: nil)
        let countryCanada = CountryModel(name: "Canada", region: "NA", capital: "Ottawa", code: "CA", currency: nil, flag: nil, language: nil)
        let countries = [countryUSA, countryCanada]
        viewController.countries = countries
        viewController.filteredCountries = countries
        viewController.filterCountries(for: "USA")
        XCTAssertEqual(viewController.filteredCountries.count, 1, "Filtered countries count should be 1")
        XCTAssertEqual(viewController.filteredCountries.first?.name, "USA", "Filtered country name should be 'USA'")
        viewController.filterCountries(for: "Canada")
        XCTAssertEqual(viewController.filteredCountries.count, 1, "Filtered countries count should be 1")
        XCTAssertEqual(viewController.filteredCountries.first?.name, "Canada", "Filtered country name should be 'Canada'")
        viewController.filterCountries(for: "")
        XCTAssertEqual(viewController.filteredCountries.count, 2, "Filtered countries count should be 2 when search text is empty")
    }
    
    func testTableViewDataSource() {
        let countryUSA = CountryModel(name: "USA", region: "NA", capital: "Washington", code: "USA", currency: nil, flag: nil, language: nil)
        let countryCanada = CountryModel(name: "Canada", region: "NA", capital: "Ottawa", code: "CA", currency: nil, flag: nil, language: nil)
        let countries = [countryUSA, countryCanada]
        viewController.countries = countries
        viewController.filteredCountries = countries
        viewController.countryTableView.reloadData()
        let numberOfRows = viewController.tableView(mockTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 2, "Number of countries")
    }
    
    func testTableViewFooterWhenNoResults() {
        viewController.isFiltering = true
        viewController.filteredCountries = []
        let footerTitle = viewController.tableView(mockTableView, titleForFooterInSection: 0)
        XCTAssertEqual(footerTitle, "No countries found", " No results are filtered")
    }
}
