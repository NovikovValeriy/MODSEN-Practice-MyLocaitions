//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

import UIKit
import CoreData

struct LocationsValues {
    static let tabBarItemTitle = "Locations"
    static let navigationTitle = "Locations"
    
    static let cellIdentifier = "LocationsCell"
    
    static let descriptionLabelText = "Fake description"
    static let addressLabelText = "Fake address"
}

class LocationsViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    //UI Elements
    private var descriptionLabel: UILabel!
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        label.text = "Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 101
        return label
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupUI()
    }
    
    // MARK: - Configuration
    
    private func configureDataSource() {
        self.tableView.register(LocationCell.self, forCellReuseIdentifier: LocationsValues.cellIdentifier)
    }
    
    private func setupUI() {
        viewControllerConfiguration()
        descriptionLabelConfiduration()
    }
    
    private func viewControllerConfiguration() {
        navigationController?.tabBarItem.title = LocationsValues.tabBarItemTitle
        title = LocationsValues.navigationTitle
    }
    
    private func descriptionLabelConfiduration() {
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptionLabel.text = "Description"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.tag = 100
    }
    
    private func addressLabelConfiduration() {
        
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsValues.cellIdentifier, for: indexPath)
        let descriptionLabel = cell.viewWithTag(100) as! UILabel
        descriptionLabel.text = LocationsValues.descriptionLabelText
        let addressLabel = cell.viewWithTag(101) as! UILabel
        addressLabel.text = LocationsValues.addressLabelText
        return cell
    }
}
