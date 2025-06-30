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
    static let addressLabelTextColor: UIColor = .secondaryLabel
    static let addressTopPadding: CGFloat = 4
    static let addressBottomPadding: CGFloat = 8
    
    static let sidesPadding: CGFloat = 16
    
    static let noDescriptionText = "(No Description)"
    
    static let noPhotoName = "No Photo"
    
    static let thumbnailSize: CGFloat = 52
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
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(photoImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: LocationCellValues.sidesPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocationCellValues.sidesPadding),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LocationCellValues.descriptionTopPadding),
            
            addressLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: LocationCellValues.sidesPadding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocationCellValues.sidesPadding),
            addressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: LocationCellValues.addressTopPadding),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LocationCellValues.addressBottomPadding)
        ])
    }
    
    // MARK: - Configuration
    func configure(for location: Location) {
        if location.locationDescription.isEmpty {
            descriptionLabel.text = LocationCellValues.noDescriptionText
        } else {
            descriptionLabel.text = location.locationDescription
        }

        if let placemark = location.placemark {
            var text = ""
            text.add(text: placemark.subThoroughfare)
            text.add(text: placemark.thoroughfare, separatedBy: " ")
            text.add(text: placemark.locality, separatedBy: ", ")
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
        photoImageView.image = thumbnail(for: location)
    }
    
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resized(withBounds: CGSize(width: LocationCellValues.thumbnailSize, height: LocationCellValues.thumbnailSize))
        }
        return UIImage(named: LocationCellValues.noPhotoName)!
    }
}
