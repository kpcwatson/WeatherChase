//
//  WeatherViewModel.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/5/23.
//

import CoreLocation
import Combine

struct WeatherModel: Sendable {
    let title: String
    let iconUrl: URL?
    let currentTemperature: Double
    let currentConditions: String
    let maximumTemperature: Double?
    let minimumTemperature: Double?
    let feelsLike: Double?
    let humidity: Int
    let pressure: Int?
    let windSpeed: Double
    let windDegree: Int
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}

extension WeatherModel {
    init(from currentCondition: CurrentCondition) {

        title = currentCondition.cityName ?? "Location"

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

        currentTemperature = currentCondition.main.temperature
        maximumTemperature = currentCondition.main.temperatureMax
        minimumTemperature = currentCondition.main.temperatureMin
        feelsLike = currentCondition.main.feelsLike
        humidity = currentCondition.main.humidity
        pressure = currentCondition.main.pressure
        windSpeed = currentCondition.wind.speed
        windDegree = currentCondition.wind.degree
        sunrise = currentCondition.system.sunrise
        sunset = currentCondition.system.sunset
    }
}
class WeatherViewModel: NSObject {

    enum Section: Int, CaseIterable {
        case title
        case main
        case additional
    }

    @Published var selectedPlace: Place? {
        didSet {
            print("set selected location: \(String(describing: selectedPlace))")
            if let place = selectedPlace {
                fetchCurrentConditions(for: place)
            }
        }
    }

    @Published var weather: WeatherModel?
    
    private var subscriptions = Set<AnyCancellable>()
    private let apiClient = OpenWeatherApiClient()

    // call to get weather

    func fetchCurrentConditions(for place: Place) {
        Task(priority: .userInitiated) {
            do {
                let conditions = try await apiClient.currentConditions(at: place.coordinate)
                let weatherModel = WeatherModel(from: conditions)
                print("weatherModel: \(weatherModel)")
                await MainActor.run {
                    weather = weatherModel
                }
            } catch {
                print(error, error.localizedDescription)
            }
        }

    }
}
