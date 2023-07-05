//
//  OpenWeatherApi.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import Foundation


enum OpenWeatherApiError: Error {
    case invalidUrl(String?)
    case invalidStatusCode(Int)
    case unknown(Error? = nil)
}

extension OpenWeatherApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl(let urlString):
            return "Could not build URL: \(urlString ?? "nil")."
        case .invalidStatusCode(let statusCode):
            return "Received invalid HTTP Response status code \(statusCode)."
        case .unknown(let error):
            return "An unknown error occurred: \(error?.localizedDescription ?? "n/a")"
        }
    }
}

extension OpenWeatherApiError: Identifiable {
    var id: String? {
        errorDescription
    }
}

// GEOCODE
// https://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
// must include country code if using state code
// https://api.openweathermap.org/geo/1.0/zip?zip={zip code},{country code}&appid={API key}

// WEATHER
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
class OpenWeatherApiClient {

    struct Coordinates {
        let latitude: Double
        let longitude: Double
    }

    func geocode(postalCode: String) async throws -> Coordinates {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "zip", value: postalCode))
        queryItems.append(URLQueryItem(name: "appid", value: "..."))

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/geo/1.0/zip"
        components.queryItems = queryItems

        guard let url = components.url else {
            throw OpenWeatherApiError.invalidUrl(components.string)
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenWeatherApiError.unknown()
        }

        guard (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) else {
            throw OpenWeatherApiError.invalidStatusCode(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GeocodeResult.self, from: data)

        return Coordinates(latitude: result.latitude, longitude: result.longitude)
    }

    func geocode(city: String) async throws -> Coordinates {
        fatalError()
//        let result = try decoder.decode([GeocodeResult].self, from: data) // decode to an array
    }

    func currentConditions(at coordinates: Coordinates) async throws -> CurrentCondition {
        fatalError()
    }

    func currentConditions(for query: String) async throws -> CurrentCondition {
        fatalError()
    }
}
