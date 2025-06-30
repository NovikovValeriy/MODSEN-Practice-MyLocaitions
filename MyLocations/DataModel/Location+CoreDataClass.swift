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

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        return locationDescription
    }
    
    public var subtitle: String? {
        return category
    }
}
