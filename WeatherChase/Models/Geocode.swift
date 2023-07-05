//
//  Geocode.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import Foundation

struct GeocodeResult: Codable {
    let cityName: String
    let latitude: Double
    let longitude: Double
    let zip: String?
    let state: String?
    let country: String

    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case latitude = "lat"
        case longitude = "lon"

        case zip, state, country
    }
}
