
import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    
    let countryLabel = UILabel()
    let codeLabel = UILabel()
    let capitalLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        capitalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countryLabel.font = UIFont.systemFont(ofSize: 16)
        codeLabel.font = UIFont.systemFont(ofSize: 16)
        capitalLabel.font = UIFont.systemFont(ofSize: 16)
        countryLabel.textColor = .black
        codeLabel.textColor = .black
        capitalLabel.textColor = .black
        
        contentView.addSubview(countryLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(capitalLabel)
        
        NSLayoutConstraint.activate([
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            codeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            capitalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            capitalLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8),
            capitalLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
}
