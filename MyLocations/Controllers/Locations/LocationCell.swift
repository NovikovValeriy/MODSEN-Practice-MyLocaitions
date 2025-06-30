//
//  LocationCell.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//


import UIKit

struct LocationCellValues {
    static let reuseIdentifier = "LocationCell"
    
    static let descriptionLabelFont: UIFont = .systemFont(ofSize: 17, weight: .bold)
    static let descriptionLabelText = "Description"
    static let descriptionTopPadding: CGFloat = 8
    
    static let addressLabelFont: UIFont = .systemFont(ofSize: 14)
    static let addressLabelText = "Address"
    static let addressLabelTextColor: UIColor = .black.withAlphaComponent(0.5)
    static let addressTopPadding: CGFloat = 4
    static let addressBottomPadding: CGFloat = 8
    
    static let sidesPadding: CGFloat = 16
}

class LocationCell: UITableViewCell {
    
    
    // MARK: - UI Elements
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = LocationCellValues.descriptionLabelFont
        label.text = LocationCellValues.descriptionLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = LocationCellValues.addressLabelFont
        label.textColor = LocationCellValues.addressLabelTextColor
        label.text = LocationCellValues.addressLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LocationCellValues.sidesPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocationCellValues.sidesPadding),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LocationCellValues.descriptionTopPadding),
            
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LocationCellValues.sidesPadding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocationCellValues.sidesPadding),
            addressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: LocationCellValues.addressTopPadding),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LocationCellValues.addressBottomPadding)
        ])
    }
    
    // MARK: - Configuration
    func configure(for location: Location) {
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        if let placemark = location.placemark {
            var text = ""
            if let thoroughfare = placemark.thoroughfare {
                text += thoroughfare + ", "
            }
            if let locality = placemark.locality {
                text += locality
            }
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
    }
}
