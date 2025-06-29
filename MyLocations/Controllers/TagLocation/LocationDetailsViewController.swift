//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 27.06.25.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct LocationDetailsValues {
    static let textViewCellIdentifier = "textViewCell"
    static let categoryCellIdentifier = "categoryCell"
    static let latitudeCellIdentifier = "latitudeCell"
    static let longitudeCellIdentifier = "longitudeCell"
    static let addressCellIdentifier = "addressCell"
    static let dateCellIdentifier = "dateCell"
    static let addPhotoCellIdentifier = "addPhotoCell"
    
    static let descriptionTextViewHeight: CGFloat = 88
    static let descriptionTextViewHeader = "Description"
    
    static let descriptionSectionID = 0
    static let photoSectionID = 1
    static let coordinatesSectionID = 2
}

class LocationDetailsViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    private let date = Date()
    
    // UI Elements
    private var descriptionTextView: UITextView!
    
    private var categoryLabel: UILabel!
    private var categoryValueLabel: UILabel!
    
    private var addPhotoLabel: UILabel!
    
    private var latitudeLabel: UILabel!
    private var latitudeValueLabel: UILabel!
    
    private var longitudeLabel: UILabel!
    private var longitudeValueLabel: UILabel!
    
    private var addressLabel: UILabel!
    private var addressValueLabel: UILabel!
    
    private var dateLabel: UILabel!
    private var dateValueLabel: UILabel!
    
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Configuration methods
    
    private func configureDataSource() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.textViewCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.categoryCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.latitudeCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.longitudeCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.addressCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.dateCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationDetailsValues.addPhotoCellIdentifier)
    }
    
    private func setupUI() {
        configureDescriptionTextView()
        configureCategoryLabel()
        configureAddPhotoLabel()
        configureLatitudeLabel()
        configureLongitudeLabel()
        configureAddressLabel()
        configureDateLabel()
        configureNavigationUI()
        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func configureDescriptionTextView() {
        descriptionTextView = UITextView()
        descriptionTextView.text = "(Description goes here)"
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryValueLabel = UILabel()
        categoryValueLabel.text = categoryName
        categoryValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddPhotoLabel() {
        addPhotoLabel = UILabel()
        addPhotoLabel.text = "Add Photo"
        addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLatitudeLabel() {
        latitudeLabel = UILabel()
        latitudeLabel.text = "Latitude"
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        latitudeValueLabel = UILabel()
        latitudeValueLabel.text = String(format: "%.8f", coordinate.latitude)
        latitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLongitudeLabel() {
        longitudeLabel = UILabel()
        longitudeLabel.text = "Longitude"
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeValueLabel = UILabel()
        longitudeValueLabel.text = String(format: "%.8f", coordinate.longitude)
        longitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddressLabel() {
        addressLabel = UILabel()
        addressLabel.text = "Address"
        addressLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addressValueLabel = UILabel()
        addressValueLabel.text = self.string(from: placemark)
        addressValueLabel.textAlignment = .right
        addressValueLabel.numberOfLines = 0
        addressValueLabel.lineBreakMode = .byWordWrapping
        addressValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addressValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateLabel() {
        dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateValueLabel = UILabel()
        dateValueLabel.text = self.format(date: date)
        dateValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationUI() {
        title = "Tag Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    // MARK: - Actions
    
    @objc private func done() {
//        let hudView = HudView.hud(animated: true)
//        hudView.text = "Tagged"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//            hudView.hide()
//            self.navigationController?.popViewController(animated: true)
//        }
        let location = Location(context: managedObjectContext)
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.placemark = placemark
        
        do {
            try managedObjectContext.save()
            let hudView = HudView.hud(animated: true)
            hudView.text = "Tagged"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    
//    @objc private func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
//        let point = gestureRecognizer.location(in: tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
//            return
//        }
//        descriptionTextView.resignFirstResponder()
//    }

    // MARK: - Table view data source

    //Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    //Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case LocationDetailsValues.descriptionSectionID:
            return 2
        case LocationDetailsValues.photoSectionID:
            return 1
        case LocationDetailsValues.coordinatesSectionID:
            return 4
        default:
            break
        }
        return 1
    }

    //Cell for index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case LocationDetailsValues.descriptionSectionID:
            switch indexPath.row {
            case 0:
                return textViewCell(tableView, indexPath)
            case 1:
                return categoryCell(tableView, indexPath)
            default:
                break
            }
        case LocationDetailsValues.photoSectionID:
            return addPhotoCell(tableView, indexPath)
        case LocationDetailsValues.coordinatesSectionID:
            switch indexPath.row {
            case 0:
                return latitudeCell(tableView, indexPath)
            case 1:
                return longitudeCell(tableView, indexPath)
            case 2:
                return addressCell(tableView, indexPath)
            case 3:
                return dateCell(tableView, indexPath)
            default:
                break
            }
            break
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    
    //Cell selection
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == LocationDetailsValues.photoSectionID
            || indexPath.section == LocationDetailsValues.descriptionSectionID {
            return indexPath
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == LocationDetailsValues.descriptionSectionID {
            if indexPath.row == 0 {
                descriptionTextView.becomeFirstResponder()
            } else {
                descriptionTextView.resignFirstResponder()
                if indexPath.row == 1 {
                    let categoryPickerVC = CategoryPickerViewController()
                    categoryPickerVC.selectedCategoryName = categoryName
                    categoryPickerVC.delegate = self
                    navigationController?.pushViewController(categoryPickerVC, animated: true)
                }
            }
        }
    }
    
    // MARK: - Cell templates
    
    //Text View Cell template
    private func textViewCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.textViewCellIdentifier, for: indexPath)
        
        cell.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: cell.layoutMarginsGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: cell.layoutMarginsGuide.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: cell.layoutMarginsGuide.topAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: cell.layoutMarginsGuide.bottomAnchor)
        ])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return LocationDetailsValues.descriptionTextViewHeight
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return LocationDetailsValues.descriptionTextViewHeader
        }
        return nil
    }
    
    //Category cell template
    private func categoryCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.categoryCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryValueLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            categoryValueLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            categoryValueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //Add Photo cell template
    private func addPhotoCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.addPhotoCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        contentView.addSubview(addPhotoLabel)
        
        NSLayoutConstraint.activate([
            addPhotoLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            addPhotoLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //Latitude cell template
    private func latitudeCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.latitudeCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        contentView.addSubview(latitudeLabel)
        contentView.addSubview(latitudeValueLabel)
        
        NSLayoutConstraint.activate([
            latitudeLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            latitudeLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            latitudeValueLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            latitudeValueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        return cell
    }
    
    //Longitude cell template
    private func longitudeCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.longitudeCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        contentView.addSubview(longitudeLabel)
        contentView.addSubview(longitudeValueLabel)
        
        NSLayoutConstraint.activate([
            longitudeLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            longitudeLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    
            longitudeValueLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            longitudeValueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        return cell
    }
    
    //Address cell template
    private func addressCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.addressCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        let stack = UIStackView(arrangedSubviews: [addressLabel, addressValueLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        return cell
    }
    
    //Date cell template
    private func dateCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDetailsValues.dateCellIdentifier, for: indexPath)
        let contentView = cell.contentView
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateValueLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    
            dateValueLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            dateValueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        return cell
    }
    
    // MARK: - Helper methods
    
    private func string(from placemark: CLPlacemark?) -> String {
        var text = ""
        if let placemark = placemark {
            if let s = placemark.subThoroughfare {
                text += s + " "
            }
            if let s = placemark.thoroughfare {
                text += s + ", "
            }
            if let s = placemark.locality {
                text += s + ", "
            }
            if let s = placemark.administrativeArea {
                text += s + " "
            }
            if let s = placemark.postalCode {
                text += s + ", "
            }
            if let s = placemark.country {
                text += s
            }
        }
        return text
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

extension LocationDetailsViewController: CategoryPickerProtocol {
    func didSelectCategory(_ categoryName: String) {
        self.categoryName = categoryName
        categoryValueLabel.text = categoryName
        navigationController?.popViewController(animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: LocationDetailsViewController())
}
