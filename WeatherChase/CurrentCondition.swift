//
//  CurrentCondition.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import Foundation

struct CurrentCondition: Codable {
    let coordinate: Coordinate
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let datetime: TimeInterval   // epoch time of data calculation
    let system: System
    let cityId: Int?
    let cityName: String?

    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case datetime = "dt"
        case cityId = "id"
        case cityName = "name"
        case system = "sys"
        case weather, main, wind, clouds
    }
}

struct Clouds: Codable {
    let all: Int    // cloudiness %
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Main: Codable {
    let temperature: Double  // Kelvin | Celsius | Fahrenheit
    let temperatureMin: Double?  // Kelvin | Celsius | Fahrenheit
    let temperatureMax: Double?  // Kelvin | Celsius | Fahrenheit
    let feelsLike: Double?  // Kelvin | Celsius | Fahrenheit
    let humidity: Int   // percent
    let pressure: Int?  // atmospheric pressure at sea level (hPa for all units)
    let seaLevel: Int?  // atmospheric pressure at sea level (hPa for all units)
    let groundLevel: Int?   // atmospheric pressure at sea level (hPa for all units)

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case feelsLike = "feels_like"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"

        case pressure, humidity
    }
}

struct System: Codable {
    let sunrise: TimeInterval    // epoch datetime
    let sunset: TimeInterval     // epoch datetime
}

struct Weather: Codable {
    let id: Int     // weather condition ID, maybe not needed https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double   // m/s (metric) or mph (imperial)
    let degree: Int     // wind direction
    let gust: Double?   // m/s (metric) or mph (imperial)

    enum CodingKeys: String, CodingKey {
        case degree = "deg"
        case speed, gust
    }
}
