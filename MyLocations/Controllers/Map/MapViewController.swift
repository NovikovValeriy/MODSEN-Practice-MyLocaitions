//
//  MapViewController.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

import UIKit
import MapKit
import CoreData

struct MapValues {
    static let title = "Map"
    static let leftBarButtonTitle = "Locations"
    static let rightBarButtonTitle = "User"
    
    static let annotationViewIdentifier = "Location"
    
    static let radius: CLLocationDistance = 1000
    
    static let regionLatitude: CLLocationDegrees = 90
    static let regionLongitude: CLLocationDegrees = 180
    
    static let extraSpace = 1.5
}

class MapViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: managedObjectContext,
                queue: nil) { [weak self] _ in
                    guard let self = self else { return }
                    if self.isViewLoaded {
                        self.updateLocations()
                    }
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
        title = MapValues.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: MapValues.leftBarButtonTitle, style: .plain, target: self, action: #selector(showLocations))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: MapValues.rightBarButtonTitle, style: .plain, target: self, action: #selector(showUser))
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
        guard let mapView = mapView else { return }
        mapView.removeAnnotations(locations)
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()
        locations = try! managedObjectContext.fetch(fetchRequest)
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
            latitudinalMeters: MapValues.radius,
            longitudinalMeters: MapValues.radius)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @objc private func showLocationDetails(_ sender: UIButton) {
        let controller = LocationDetailsViewController()
        controller.managedObjectContext = managedObjectContext
        controller.locationToEdit = locations[sender.tag]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Controller logic methods
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        switch annotations.count {
        case 0:
            region = MKCoordinateRegion(
                center: mapView.userLocation.coordinate,
                latitudinalMeters: MapValues.radius,
                longitudinalMeters: MapValues.radius
            )
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: MapValues.radius,
                longitudinalMeters: MapValues.radius
            )
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -MapValues.regionLatitude, longitude: MapValues.regionLongitude)
            var bottomRight = CLLocationCoordinate2D(latitude: MapValues.regionLatitude, longitude: -MapValues.regionLongitude)
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
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * MapValues.extraSpace,
                longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * MapValues.extraSpace
            )
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Location else {
            return nil
        }
        let identifier = MapValues.annotationViewIdentifier
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
