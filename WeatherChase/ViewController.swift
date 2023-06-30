//
//  ViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit

// GEOCODE
// http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
// must include country code if using state code
// http://api.openweathermap.org/geo/1.0/zip?zip={zip code},{country code}&appid={API key}

// WEATHER
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

// ICONS
// http://openweathermap.org/img/wn/{icon}@2x.png
// for caching, icon responses include ETag, last-modified and cache-control: max-age

class ViewController: UIViewController {

//    @IBOutlet var searchBar: UISearchBar!

    var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        navigationItem.titleView = searchBar

        resultsTableViewController = storyboard?.instantiateViewController(withIdentifier: "ResultsTableViewController") as? ResultsTableViewController
//        searchResultsViewController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.delegate = self    // TODO: delete if not needed
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint("UISearchResultsUpdating invoked method: \(#function).")
        
        guard let text = searchController.searchBar.text else { return }

//        let strippedString = text.trimmingCharacters(in: .whitespaces)
        // perform search, display results in results tableviewcontroller
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function, "searchText: \(searchText)")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
        // perform search
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)

        searchBar.resignFirstResponder()
        // perform search
    }
}

// TODO: delete if not needed
extension ViewController: UISearchControllerDelegate {
//    func presentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func willPresentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func didPresentSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func willDismissSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
//
//    func didDismissSearchController(_ searchController: UISearchController) {
//        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
//    }
}

