//
//  Place.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/6/23.
//

import Foundation
import CoreLocation

struct Place: Codable, Sendable {
    let name: String
    let coordinate: Coordinate
}

struct Coordinate: Codable, Sendable {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    init(from location: CLLocation) {
        self.init(from: location.coordinate)
    }

    init(from coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
