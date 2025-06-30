//
//  MapViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            NotificationCenter.default.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: managedObjectContext,
                queue: nil) { _ in
                    self.updateLocations()
                }
        }
    }
    private var locations = [Location]()
    
    //UI Elements
    private var mapView: MKMapView!

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLocations()
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    // MARK: - Configuration
    private func setupUI() {
        navigationBarConfiguration()
        mapViewConfiguration()
    }
    
    private func navigationBarConfiguration() {
        title = "Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Locations", style: .plain, target: self, action: #selector(showLocations))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "User", style: .plain, target: self, action: #selector(showUser))
    }
    
    private func mapViewConfiguration() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Data fetching
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()
        do {
            locations = try managedObjectContext!.fetch(fetchRequest)
        } catch {
            fatalError("Could not fetch locations: \(error.localizedDescription)")
        }
        mapView.addAnnotations(locations)
    }
    
    // MARK: - Actions
    
    @objc private func showLocations() {
        let region = region(for: locations)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func showUser() {
        let region = MKCoordinateRegion(
            center: mapView.userLocation.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func showLocationDetails(_ sender: UIButton) {
        let controller = LocationDetailsViewController()
        controller.locationToEdit = locations[sender.tag]
        controller.managedObjectContext = managedObjectContext
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Controller logic methods
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        switch annotations.count {
        case 0:
            region = MKCoordinateRegion(
                center: mapView.userLocation.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            for annotation in annotations {
                topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
                bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2
            )
            let extraSpace = 1.1
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace,
                longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace
            )
            region = MKCoordinateRegion(center: center, span: span)
        }
        return region
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Location else {
            return nil
        }
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(showLocationDetails), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .green
        let button = annotationView?.rightCalloutAccessoryView as! UIButton
        if let index = locations.firstIndex(of: annotation) {
            button.tag = index
        }
        return annotationView
    }
}
