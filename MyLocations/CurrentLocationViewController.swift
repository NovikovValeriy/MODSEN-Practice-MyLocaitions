//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 25.06.25.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    
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
    
    // MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.title = "Tag"
        
        setupUI()
    }

    // MARK: - Configuration

    private func setupUI() {
        safeAreaViewConfiguration()
        
        messageLabelConfiguration()
        latitudeLabelsConfiguration()
        longitudeLabelsConfiguration()
        addressLabelConfiguration()
        tagButtonConfiguration()
        getButtonConfiguration()
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
        
        messageLabel.backgroundColor = .yellow
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func latitudeLabelsConfiguration() {
        latitudeLabel = UILabel()
        latitudeLabel.text = "Latitude:"
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeValueLabel = UILabel()
        latitudeValueLabel.text = "(Latitude goes here)"
        latitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        latitudeStack = UIStackView(arrangedSubviews: [latitudeLabel, latitudeValueLabel])
        latitudeStack.axis = .horizontal
        latitudeStack.translatesAutoresizingMaskIntoConstraints = false

        latitudeStack.backgroundColor = .yellow
        
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
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeValueLabel = UILabel()
        longitudeValueLabel.text = "(Longitude goes here)"
        longitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeStack = UIStackView(arrangedSubviews: [longitudeLabel, longitudeValueLabel])
        longitudeStack.axis = .horizontal
        longitudeStack.translatesAutoresizingMaskIntoConstraints = false

        longitudeStack.backgroundColor = .yellow
        
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
        
        addressLabel.backgroundColor = .yellow
        
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
        
        tagButton.backgroundColor = .yellow
        
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
        
        getButton.backgroundColor = .yellow
        
        view.addSubview(getButton)
        
        NSLayoutConstraint.activate([
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

#Preview {
    let rootVC = CurrentLocationViewController()
    //let tabBarController = UITabBarController()
    //tabBarController.setViewControllers([rootVC], animated: false)
    //tabBarController
    rootVC
}
