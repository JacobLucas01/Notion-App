//
//  BusinessModel.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/11/23.
//

import Foundation
import MapKit

struct Landmark {
    
    var placemark: MKPlacemark
    var id: UUID { return UUID() }
    var name: String { self.placemark.name ?? ""}
    var address: String { self.placemark.title ?? "" }
    var coordinate: CLLocationCoordinate2D { self.placemark.coordinate }
    
}
