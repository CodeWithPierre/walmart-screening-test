import Foundation
import UIKit

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var filteredCountries: [CountryModel] = []
    private var countries: [CountryModel] = []
    private let viewModel = CountryViewModel()
    private var isFiltering = false
    private var searchBar: UISearchBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupSearchController()
        viewModel.fetchCountries()
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
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
                self?.tableView.reloadData()
            }
        }
    }
    
    private func filterCountries(for searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
            filteredCountries = countries
        } else {
            isFiltering = true
            filteredCountries = countries.filter { country in
                let searchTextLowercased = searchText.lowercased()
                return (country.name?.lowercased().contains(searchTextLowercased) ?? false) ||
                (country.capital?.lowercased().contains(searchTextLowercased) ?? false)
            }
        }
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.tableView.reloadData()
        })
    }
}

// MARK: - TableView DataSource & Delegate Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCountries.count : countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryTableViewCell
        let country = isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.row]
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
