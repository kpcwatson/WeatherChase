//
//  WeatherViewModel.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/5/23.
//

import CoreLocation
import Combine

private let selectedPlaceKey = "SelectedPlace"

class WeatherViewModel: NSObject {

    @Published var selectedPlace: Place? {
        didSet {
            if let place = selectedPlace {
                fetchCurrentConditions(for: place)
                persistPlaceInUserDefaults(place)
            }
        }
    }

    @Published var currentWeather: CurrentWeather?

    private let apiClient = OpenWeatherApiClient()
    private var subscriptions = Set<AnyCancellable>()

    private lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    override init() {
        super.init()

        if let place = retrievePlaceFromUserDefaults() {
            selectedPlace = place
        }
    }

    private func persistPlaceInUserDefaults(_ place: Place) {
        let encoder = PropertyListEncoder()
        let encodedPlace = try? encoder.encode(place)
        UserDefaults.standard.set(encodedPlace, forKey: selectedPlaceKey)
    }

    private func retrievePlaceFromUserDefaults() -> Place? {
        guard let encodedPlace = UserDefaults.standard.value(forKey: selectedPlaceKey) as? Data else {
            return nil
        }
        let decoder = PropertyListDecoder()
        let place = try? decoder.decode(Place.self, from: encodedPlace)
        return place
    }

    private func fetchCurrentConditions(for place: Place) {
        Task(priority: .userInitiated) {
            do {
                let conditions = try await apiClient.currentConditions(at: place.coordinate)
                await MainActor.run {
                    currentWeather = CurrentWeather(from: conditions)
                }
            } catch {
                print(error, error.localizedDescription)
            }
        }
    }
}

// MARK: - User's Location
extension WeatherViewModel {

}

// MARK: - Formatted strings for displaying in UI
extension WeatherViewModel {

    var placeLabelText: String? {
        guard let title = currentWeather?.title else { return nil }
        return title
    }

    var currentTempLabelText: String? {
        guard let temp = currentWeather?.currentTemperature else { return nil }
        return "\(temp)º F"
    }

    var currentConditionsLabelText: String? {
        guard let conditions = currentWeather?.currentConditions else { return nil }
        return conditions
    }

    var highTempLabelText: String? {
        guard let max = currentWeather?.maximumTemperature else { return nil }
        return "HI: \(max)º F"
    }

    var lowTempLabel: String? {
        guard let min = currentWeather?.minimumTemperature else { return nil }
        return "LO: \(min)º F"
    }

    var humidityLabelText: String? {
        guard let humidity = currentWeather?.humidity else { return nil }
        return "Humidity: \(humidity)%"
    }

    var feelsLikeLabelText: String? {
        guard let feelsLike = currentWeather?.feelsLike else { return nil }
        return "Feels Like \(feelsLike)º F"
    }

    var sunriseLabelText: String? {
        guard let sunrise = currentWeather?.sunrise else { return nil }
        return "Sunrise: \(dateFormatter.string(from: Date(timeIntervalSince1970: sunrise)))"
    }

    var sunsetLabelText: String? {
        guard let sunset = currentWeather?.sunset else { return nil }
        return "Sunset: \(dateFormatter.string(from: Date(timeIntervalSince1970: sunset)))"
    }
}
