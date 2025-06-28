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
    
    private var updatingLocation = false
    private var lastLocationError: Error?
    
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var performingReverseGeocoding = false
    private var lastGeocodingError: Error?
    
    private var timer: Timer?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
        tagButton.addTarget(self, action: #selector(goToTagLocation), for: .touchUpInside)
        
        view.addSubview(tagButton)
        
        NSLayoutConstraint.activate([
            tagButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tagButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func getButtonConfiguration() {
        getButton = UIButton(type: .system)
        getButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        
        getButtonTitleConfiguration()
        
        //getButton.backgroundColor = .yellow
        
        view.addSubview(getButton)
        
        NSLayoutConstraint.activate([
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func getButtonTitleConfiguration() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
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
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    @objc private func goToTagLocation() {
        let locationDetailsVC = LocationDetailsViewController()
        locationDetailsVC.coordinate = location!.coordinate
        locationDetailsVC.placemark = placemark
        navigationController?.pushViewController(locationDetailsVC, animated: true)
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
    
    private func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = Timer.scheduledTimer(
                timeInterval: 60,
                target: self,
                selector: #selector(didTimeOut),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc private func didTimeOut() {
        print("*** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(
                domain: "MyLocationsErrorDomain",
                code: 1,
                userInfo: nil
            )
            updateLabels()
        }
    }
    
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    private func updateLabels() {
        if let location = location {
            latitudeValueLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeValueLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        } else {
            latitudeValueLabel.text = ""
            longitudeValueLabel.text = ""
            tagButton.isHidden = true
            
            var statusMessage: String = "Tap 'Get My Location' to Start"
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            }
            messageLabel.text = statusMessage
        }
        getButtonTitleConfiguration()
    }
    
    private func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let tmp = placemark.subThoroughfare {
            line1 += tmp + " "
        }
        if let tmp = placemark.subThoroughfare {
            line1 += tmp
        }
        var line2 = ""
        if let tmp = placemark.locality {
            line2 += tmp + " "
        }
        if let tmp = placemark.administrativeArea {
            line2 += tmp + " "
        }
        if let tmp = placemark.postalCode {
            line2 += tmp
        }
        return line1 + "\n" + line2
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFaildWithError: \(error.localizedDescription)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations: \(newLocation)")
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                if distance > 0 {
                    performingReverseGeocoding = false
                }
                stopLocationManager()
            }
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation) { [weak self] placemarks, error in
                    guard let self = self else { return }
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        self.placemark = places.first!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                }
            }
            updateLabels()
        } else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
            }
        }
    }
}

#Preview {
    let rootVC = CurrentLocationViewController()
    let rootNavigationVC = UINavigationController(rootViewController: rootVC)
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers([rootNavigationVC], animated: false)
    return tabBarController
}
