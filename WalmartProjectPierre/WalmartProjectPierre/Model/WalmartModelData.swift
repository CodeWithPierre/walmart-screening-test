
import Foundation

struct CountryModel: Codable {
    let name: String?
    let region: String?
    let capital: String?
    let code: String?
    let currency: Currency?
    let flag: String?
    let language: Language?
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Language: Codable {
    let code: String?
    let name: String? 
}
