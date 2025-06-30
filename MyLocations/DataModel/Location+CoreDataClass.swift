//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Валерий Новиков on 29.06.25.
//
//

import Foundation
import CoreData
import MapKit

struct LocationValues {
    static let noPhotoIDSet = "No photo ID set"
    static let photoID = "PhotoID"
    static let noDescriptionText = "(No Description)"
}

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoURL: URL {
        assert(photoID != nil, LocationValues.noPhotoIDSet)
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: LocationValues.photoID) + 1
        userDefaults.set(currentID, forKey: LocationValues.photoID)
        return currentID
    }
    
    func removePhotoFile() {
      if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        if locationDescription.isEmpty {
            return LocationValues.noDescriptionText
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }
}
