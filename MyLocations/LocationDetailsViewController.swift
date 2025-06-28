//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 27.06.25.
//

import UIKit

struct LocationDetailsValues {
    static let textViewCellIdentifier = "textViewCell"
    static let categoryCellIdentifier = "categoryCell"
    static let latitudeCellIdentifier = "latitudeCell"
    static let longitudeCellIdentifier = "longitudeCell"
    static let addressCellIdentifier = "addressCell"
    static let dateCellIdentifier = "dateCell"
    static let addPhotoCellIdentifier = "addPhotoCell"
}

class LocationDetailsViewController: UITableViewController {

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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    }
    
    private func configureDescriptionTextView() {
        descriptionTextView = UITextView()
        descriptionTextView.text = "(Description goes here)"
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryValueLabel = UILabel()
        categoryValueLabel.text = "Detail"
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
        latitudeValueLabel.text = "Detail"
        latitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLongitudeLabel() {
        longitudeLabel = UILabel()
        longitudeLabel.text = "Longitude"
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeValueLabel = UILabel()
        longitudeValueLabel.text = "Detail"
        longitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddressLabel() {
        addressLabel = UILabel()
        addressLabel.text = "Address"
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addressValueLabel = UILabel()
        addressValueLabel.text = "Detail"
        addressValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateLabel() {
        dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateValueLabel = UILabel()
        dateValueLabel.text = "Detail"
        dateValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationUI() {
        title = "Tag Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    // MARK: - Actions
    
    @objc private func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    //Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    //Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 4
        default:
            break
        }
        return 1
    }

    //Cell template
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return textViewCell(tableView, indexPath)
            case 1:
                return categoryCell(tableView, indexPath)
            default:
                break
            }
        case 1:
            return addPhotoCell(tableView, indexPath)
        case 2:
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
        if indexPath.section == 1 || indexPath.section == 0 && indexPath.row == 1 {
            return indexPath
        }
        return nil
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
            return 88.0
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Description"
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
        
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressValueLabel)
        
        NSLayoutConstraint.activate([
            addressLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    
            addressValueLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            addressValueLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
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
}

#Preview {
    UINavigationController(rootViewController: LocationDetailsViewController())
}
