//
//  CLLocation.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/13/23.
//

import Foundation
import CoreLocation

extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
