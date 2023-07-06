//
//  OpenWeatherApi.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import Foundation
import Combine

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

class OpenWeatherApiClient {

    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        return components
    }

    enum Paths: String {
        case geocodeZip = "/geo/1.0/zip"
        case geocodeQuery = "/geo/1.0/direct"
        case currentWeather = "/data/2.5/weather"
    }

    func geocode(postalCode: String) async throws -> Coordinate {
        fatalError()
    }

    func geocode(city: String) async throws -> Coordinate {
        fatalError()
    }

    func currentConditions(for query: String) async throws -> CurrentCondition {
        fatalError()
    }

    func currentConditions(at coordinate: Coordinate) async throws -> CurrentCondition {
        let queryItems = [  // TODO: make composable
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: OPENWEATHER_APP_ID),
            URLQueryItem(name: "units", value: "imperial")   // TODO: make configurable
        ]

        let url = try buildUrl(path: .currentWeather, queryItems: queryItems)

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenWeatherApiError.unknown()
        }

        guard (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) else {
            throw OpenWeatherApiError.invalidStatusCode(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(CurrentCondition.self, from: data)
        return result
    }

    private func buildUrl(path: Paths, queryItems: [URLQueryItem]) throws -> URL {
        var components = urlComponents
        components.path = Paths.currentWeather.rawValue
        components.queryItems = queryItems
        guard let url = components.url else {
            throw OpenWeatherApiError.invalidUrl(components.string)
        }
        return url
    }
}
