//
//  ViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit
import Combine
import CoreLocation // TODO: remove

// ICONS
// https://openweathermap.org/img/wn/{icon}@2x.png
// for caching, icon responses include ETag, last-modified and cache-control: max-age

class MainViewController: UIViewController {

//    private var weatherViewModel = WeatherViewModel()
    private var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!

    private var geocodeTask: Task<Void, Error>?
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableViewController = storyboard?.instantiateViewController(withIdentifier: "ResultsTableViewController") as? ResultsTableViewController

        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true

        resultsTableViewController.selectedLocationSubject
            .sink { location in
                //
                print("location> \(location)")
            }
            .store(in: &subscriptions)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: UISearchResultsUpdating {

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
