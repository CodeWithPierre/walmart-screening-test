import Foundation
import UIKit

class ViewController: UIViewController {
    
    var countryTableView: UITableView!
    var searchController: UISearchController!
    var filteredCountries: [CountryModel] = []
    var countries: [CountryModel] = []
    var viewModel = CountryViewModel()
    var isFiltering = false
    var searchBar: UISearchBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchCountries()
        setupUI()
        setupBinding()
        setupSearchController()
        self.countryTableView.reloadData()
    }
    
    // MARK: - Set up UI
    private func setupUI() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search by name or capital"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        countryTableView = UITableView(frame: .zero, style: .plain)
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.rowHeight = UITableView.automaticDimension
        countryTableView.estimatedRowHeight = 50
        countryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryCell")
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryTableView)
        
        NSLayoutConstraint.activate([
            countryTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            countryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or capital"
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup Binding
    private func setupBinding() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.countries = self?.viewModel.countries ?? []
                self?.filteredCountries = self?.countries ?? []
                self?.countryTableView.reloadData()
            }
        }
    }
    
    func filterCountries(for searchText: String) {
        if searchText.isEmpty {
            self.isFiltering = false
            self.filteredCountries = countries
        } else {
            isFiltering = true
            self.filteredCountries = countries.filter { country in
                let searchTextLowercased = searchText.lowercased()
                return (country.name?.lowercased().contains(searchTextLowercased) ?? false) ||
                (country.capital?.lowercased().contains(searchTextLowercased) ?? false)
            }
        }
        countryTableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.countryTableView.reloadData()
        })
    }
}

// MARK: - TableView DataSource & Delegate Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryTableViewCell
        let country = viewModel.getCountry(at: indexPath.row)
        cell.countryLabel.text = "\(country.name ?? ""), \(country.region ?? "")"
        cell.codeLabel.text = country.code
        cell.capitalLabel.text = country.capital
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if isFiltering && filteredCountries.isEmpty {
            return "No countries found"
        }
        return nil
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCountries(for: searchText)
        }
    }
}

// MARK: - UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterCountries(for: "")
    }
}
