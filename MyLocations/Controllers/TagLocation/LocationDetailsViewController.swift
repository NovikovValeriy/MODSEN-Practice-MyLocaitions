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
    static let titleText = "Edit Location"
    
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
    
    static let noCategoryText = "No Category"
    
    static let categoryLabelText = "Category"
    static let addPhotoLabelText = "Add Photo"
    static let latitudeLabelText = "Latitude"
    static let longitudeLabelText = "Longitude"
    static let addressLabelText = "Address"
    static let noAddressFoundText = "No Address Found"
    static let dateLabelText = "Date"
    
    static let editLocationTitle = "Edit Location"
    static let tagLocationTitle = "Tag Location"
    
    static let updatedHudViewText = "Updated"
    static let taggedHudViewText = "Tagged"
    
    static let imageViewCompressedHeightConstant: CGFloat = 44
    
    static let photoCancelTitle = "Cancel"
    static let photoTakePhotoTitle = "Take Photo"
    static let photoChoosePhotoTitle = "Choose From Library"
}

class LocationDetailsViewController: UITableViewController {
    
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext!
    var descriptionText = ""
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = LocationDetailsValues.noCategoryText
    var image: UIImage?
    var date = Date()
    var observer: Any!
    
    // UI Elements
    private var descriptionTextView: UITextView!
    
    private var categoryLabel: UILabel!
    private var categoryValueLabel: UILabel!
    
    private var imageView: UIImageView!
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
    
    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        listenForBackgroundNotification()
        
        configureDataSource()
        setupUI()
        if let location = locationToEdit {
            title = LocationDetailsValues.titleText
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    show(image: theImage)
                }
            }
        }
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
        configureImageView()
        configureLatitudeLabel()
        configureLongitudeLabel()
        configureAddressLabel()
        configureDateLabel()
        configureNavigationUI()
    }
    
    private func configureDescriptionTextView() {
        if let location = locationToEdit {
            descriptionText = location.locationDescription
        }
        descriptionTextView = UITextView()
        descriptionTextView.text = descriptionText
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.text = LocationDetailsValues.categoryLabelText
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryValueLabel = UILabel()
        categoryValueLabel.text = categoryName
        categoryValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddPhotoLabel() {
        addPhotoLabel = UILabel()
        addPhotoLabel.text = LocationDetailsValues.addPhotoLabelText
        addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureImageView() {
        imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLatitudeLabel() {
        latitudeLabel = UILabel()
        latitudeLabel.text = LocationDetailsValues.latitudeLabelText
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        latitudeValueLabel = UILabel()
        latitudeValueLabel.text = String(format: "%.8f", coordinate.latitude)
        latitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLongitudeLabel() {
        longitudeLabel = UILabel()
        longitudeLabel.text = LocationDetailsValues.longitudeLabelText
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeValueLabel = UILabel()
        longitudeValueLabel.text = String(format: "%.8f", coordinate.longitude)
        longitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddressLabel() {
        addressLabel = UILabel()
        addressLabel.text = LocationDetailsValues.addressLabelText
        addressLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addressValueLabel = UILabel()
        if let placemark = placemark {
            addressValueLabel.text = self.string(from: placemark)
        } else {
            addressValueLabel.text = LocationDetailsValues.noAddressFoundText
        }
        addressValueLabel.textAlignment = .right
        addressValueLabel.numberOfLines = 0
        addressValueLabel.lineBreakMode = .byWordWrapping
        addressValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addressValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateLabel() {
        dateLabel = UILabel()
        dateLabel.text = LocationDetailsValues.dateLabelText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateValueLabel = UILabel()
        dateValueLabel.text = self.format(date: date)
        dateValueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationUI() {
        if locationToEdit != nil {
            title = LocationDetailsValues.editLocationTitle
        } else {
            title = LocationDetailsValues.tagLocationTitle
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    // MARK: - Actions
    
    @objc private func done() {
        let hudView = HudView.hud(animated: true)
        
        let location: Location
        if let temp = locationToEdit {
            hudView.text = LocationDetailsValues.updatedHudViewText
            location = temp
        } else {
            hudView.text = LocationDetailsValues.taggedHudViewText
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.placemark = placemark
        
        //Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        //Save location
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
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
        switch indexPath.section {
        case LocationDetailsValues.descriptionSectionID:
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
        case LocationDetailsValues.photoSectionID:
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        default:
            break
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
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            addPhotoLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            addPhotoLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: addPhotoLabel.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: LocationDetailsValues.imageViewCompressedHeightConstant)
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
    
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification,
            object: nil, queue: OperationQueue.main) { [weak self] _ in
            if let weakSelf = self {
                if weakSelf.presentedViewController != nil {
                    weakSelf.dismiss(animated: false, completion: nil)
                }
                weakSelf.descriptionTextView.resignFirstResponder()
            }
        }
    }
    
    private func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        tableView.reloadData()
    }
    
    private func string(from placemark: CLPlacemark) -> String {
        var line = ""
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatedBy: " ")
        line.add(text: placemark.locality, separatedBy: ", ")
        line.add(text: placemark.administrativeArea, separatedBy: ", ")
        line.add(text: placemark.postalCode, separatedBy: " ")
        line.add(text: placemark.country, separatedBy: ", ")
        return line
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

extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }

    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: LocationDetailsValues.photoCancelTitle, style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: LocationDetailsValues.photoTakePhotoTitle, style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: LocationDetailsValues.photoChoosePhotoTitle, style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

#Preview {
    UINavigationController(rootViewController: LocationDetailsViewController())
}
