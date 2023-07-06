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

    private var weatherViewModel = WeatherViewModel()

    private var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableViewController = storyboard?.instantiateViewController(
            identifier: "ResultsTableViewController",
            creator: createResultsController)

        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = resultsTableViewController.searchViewModel
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func createResultsController(_ coder: NSCoder) -> ResultsTableViewController? {
        let searchViewModel = SearchViewModel()
        
        searchViewModel.selectedLocationSubject
            .sink { [weak self] location in
                self?.searchController.dismiss(animated: true)

                // clear out search
                self?.searchController.searchBar.text = nil
                self?.searchController.searchBar.searchTextField.text = nil

                // store in user defaults
                self?.weatherViewModel.selectedLocation = location
            }
            .store(in: &subscriptions)

        return ResultsTableViewController(coder: coder, viewModel: searchViewModel)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
