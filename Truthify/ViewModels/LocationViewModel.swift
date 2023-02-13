//
//  LocationViewModel.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/14/23.
//

import Foundation
import CoreLocation

class LocationViewModel: ObservableObject {
    
    @Published var businessCoordinates: String?
    
    func coordinateToString(coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        return "\(latitude)\(longitude)"
    }
}
