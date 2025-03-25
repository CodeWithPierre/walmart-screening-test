
import Foundation

class CountryViewModel {
    private let apiService = APIService()
    var countries: [CountryModel] = []
    var reloadData: (() -> Void)?
    
    func fetchCountries() {
        apiService.fetchCountries { [weak self] result in
            switch result {
            case.success(let countries):
                DispatchQueue.main.async {
                    self?.countries = countries
                    self?.reloadData?()
                }
            case.failure(let error):
                // I used print but in the code base we can log error and if any message do display/
                print("Error fetching countries: \(error)")
            }
        }
    }
    
    func getCountry( at index: Int) -> CountryModel {
        return self.countries[index]
    }
    
}
