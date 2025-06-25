//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 25.06.25.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    
    // UI Elements
    private var messageLabel: UILabel!
    
    private var latitudeLabel: UILabel!
    private var latitudeValueLabel: UILabel!
    private var latitudeStack: UIStackView!
    
    private var longitudeLabel: UILabel!
    private var longitudeValueLabel: UILabel!
    private var longitudeStack: UIStackView!
    
    private var addressLabel: UILabel!
    private var tagButton: UIButton!
    private var getButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        updateLabels()
    }

    // MARK: - Configuration

    private func setupUI() {
        //safeAreaViewConfiguration()
        
        viewControllerConfiguration()
        
        messageLabelConfiguration()
        latitudeLabelsConfiguration()
        longitudeLabelsConfiguration()
        addressLabelConfiguration()
        tagButtonConfiguration()
        getButtonConfiguration()
    }
    
    private func viewControllerConfiguration() {
        tabBarItem.title = "Tag"
    }
    
    private func safeAreaViewConfiguration() {
        let safeArea = UIView()
        safeArea.backgroundColor = .lightGray
        safeArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeArea)
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            safeArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func messageLabelConfiguration() {
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "(Message Label)"
        
        //messageLabel.backgroundColor = .yellow
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func latitudeLabelsConfiguration() {
        latitudeLabel = UILabel()
        latitudeLabel.text = "Latitude:"
        latitudeValueLabel = UILabel()
        latitudeValueLabel.text = "(Latitude goes here)"
        
        latitudeStack = UIStackView(arrangedSubviews: [latitudeLabel, latitudeValueLabel])
        latitudeStack.axis = .horizontal
        latitudeStack.translatesAutoresizingMaskIntoConstraints = false

        //latitudeStack.backgroundColor = .yellow
        
        view.addSubview(latitudeStack)
        
        NSLayoutConstraint.activate([
            latitudeStack.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            latitudeStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            latitudeStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func longitudeLabelsConfiguration() {
        longitudeLabel = UILabel()
        longitudeLabel.text = "Longitude:"
        longitudeValueLabel = UILabel()
        longitudeValueLabel.text = "(Longitude goes here)"
        
        longitudeStack = UIStackView(arrangedSubviews: [longitudeLabel, longitudeValueLabel])
        longitudeStack.axis = .horizontal
        longitudeStack.translatesAutoresizingMaskIntoConstraints = false

        //longitudeStack.backgroundColor = .yellow
        
        view.addSubview(longitudeStack)
        
        NSLayoutConstraint.activate([
            longitudeStack.topAnchor.constraint(equalTo: latitudeStack.bottomAnchor, constant: 20),
            longitudeStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            longitudeStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func addressLabelConfiguration() {
        addressLabel = UILabel()
        addressLabel.text = "(Address goes here)"
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //addressLabel.backgroundColor = .yellow
        
        view.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: longitudeStack.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func tagButtonConfiguration() {
        tagButton = UIButton(type: .system)
        tagButton.setTitle("Tag Location", for: .normal)
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        
        //tagButton.backgroundColor = .yellow
        
        view.addSubview(tagButton)
        
        NSLayoutConstraint.activate([
            tagButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tagButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func getButtonConfiguration() {
        getButton = UIButton(type: .system)
        getButton.setTitle("Get My Location", for: .normal)
        getButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        
        //getButton.backgroundColor = .yellow
        
        view.addSubview(getButton)
        
        NSLayoutConstraint.activate([
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func getLocation() {
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
        case .denied, .restricted:
            showLocationsServicesDeniedAlert()
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        default:
            break
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Helper methods
    
    private func showLocationsServicesDeniedAlert() {
        let alertController = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services in your device settings",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateLabels() {
        if let location = location {
            latitudeValueLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeValueLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeValueLabel.text = ""
            longitudeValueLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to start"
        }
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFaildWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        updateLabels()
        print("didUpdateLocations: \(location)")
    }
}

#Preview {
    let rootVC = CurrentLocationViewController()
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers([rootVC], animated: false)
    return tabBarController
    //rootVC
}
