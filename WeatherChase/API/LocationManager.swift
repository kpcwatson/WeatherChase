//
//  LocationManager.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/6/23.
//

import CoreLocation
import Combine

class LocationManager: NSObject {

    private let locationManager = CLLocationManager()
    let locationSubject = PassthroughSubject<Place, Error>()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.activityType = .other
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        debugPrint(#function)
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .restricted, .denied:
            break

        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint(#function, locations)
        guard let location = locations.first else { return }
        let place = Place(name: "Your Location",
                          coordinate: Coordinate(from: location))
        locationSubject.send(place)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.send(completion: .failure(error))
    }
}
