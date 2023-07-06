//
//  CurrentWeather.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/6/23.
//

import Foundation

struct CurrentWeather: Sendable {
    let title: String
    let iconUrl: URL?
    let currentTemperature: Int
    let currentConditions: String
    let maximumTemperature: Int?
    let minimumTemperature: Int?
    let feelsLike: Int?
    let humidity: Int
    let pressure: Int?
    let windSpeed: Double
    let windDegree: Int
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}

extension CurrentWeather {
    init(from currentCondition: CurrentCondition) {

        title = currentCondition.cityName ?? "Current Weather"

        iconUrl = {
            if let icon = currentCondition.weather.first?.icon {
                return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
            } else {
                return nil
            }
        }()

        currentConditions = currentCondition.weather
            .map({ $0.main })
            .joined(separator: ", ")

        currentTemperature = Int(currentCondition.main.temperature)
        maximumTemperature = Int(currentCondition.main.temperatureMax)
        minimumTemperature = Int(currentCondition.main.temperatureMin)
        feelsLike = Int(currentCondition.main.feelsLike)
        humidity = currentCondition.main.humidity
        pressure = currentCondition.main.pressure
        windSpeed = currentCondition.wind.speed
        windDegree = currentCondition.wind.degree
        sunrise = currentCondition.system.sunrise
        sunset = currentCondition.system.sunset
    }
}

private extension Int {
    init?(_ source: Double?) {
        guard let source = source else { return nil }
        self.init(source)
    }
}
