//
//  WeatherViewModel.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/5/23.
//

import CoreLocation
import UIKit
import Combine

class WeatherViewModel: NSObject {

    @Published
    var selectedLocation: CLLocation? {
        didSet {
            print("set selected location: \(String(describing: selectedLocation))")
        }
    }



    private var subscriptions = Set<AnyCancellable>()

//    func buildSearchController(resultsController: ResultsTableViewController) -> UISearchController {
//
//        searchController = UISearchController(searchResultsController: resultsController)
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
//
//        resultsController.selectedLocationSubject
//            .sink { location in
//                print("location: \(location)")
//            }
//            .store(in: &subscriptions)
//
//        return searchController
//    }

    // call to geocode

    // call to get weather
}

/*
extension WeatherViewModel: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        let trimmedText = text.trimmingCharacters(in: .whitespaces)

        guard trimmedText.count > 0 else { return }

        let geocoder = CLGeocoder()
        geocoder.cancelGeocode()

        geocodeTask?.cancel()
        geocodeTask = Task.detached(priority: .userInitiated) { [unowned self] in
            let placemarks = try await geocoder.geocodeAddressString(trimmedText)

            await MainActor.run {
                resultsTableViewController.placemarks = placemarks
                geocodeTask = nil
            }
        }
    }
}
*/
