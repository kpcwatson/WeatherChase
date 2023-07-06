//
//  ViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit
import Combine
import Kingfisher

// ICONS
// https://openweathermap.org/img/wn/{icon}@2x.png
// for caching, icon responses include ETag, last-modified and cache-control: max-age

let OPENWEATHER_APP_ID = "19b5ed9208de3282221235240f1cf119"

// TODO: need to populate from user defaults

/**
    Notes:
    1. Using Core Location for geocode instead of OpenWeather's API, since splitting the query into zip vs. city/state would have been more work.
    2. Would ideally use a collection view.
    3. Needs better error handling.
 */
class MainViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // NOTE: Ideally would make all of these separate views and cells instead of having so many outlets to one view controller
    @IBOutlet weak var weatherStackView: UIStackView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!

    private var weatherViewModel = WeatherViewModel()

    private var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherStackView.isHidden = true

        setupSearchController()

        weatherViewModel.$currentWeather
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                self?.populateContent()
            }
            .store(in: &subscriptions)
    }

    func populateContent() {
        iconImageView.kf.setImage(with: weatherViewModel.currentWeather?.iconUrl)

        placeLabel.text = weatherViewModel.placeLabelText
        currentTempLabel.text = weatherViewModel.currentTempLabelText
        conditionLabel.text = weatherViewModel.currentConditionsLabelText
        highTempLabel.text = weatherViewModel.highTempLabelText
        lowTempLabel.text = weatherViewModel.lowTempLabel
        humidityLabel.text = weatherViewModel.humidityLabelText
        feelsLikeLabel.text = weatherViewModel.feelsLikeLabelText
        sunriseLabel.text = weatherViewModel.sunriseLabelText
        sunsetLabel.text = weatherViewModel.sunsetLabelText

        activityIndicator.stopAnimating()
        weatherStackView.isHidden = false
    }
}

// MARK: - Setup SearchController
extension MainViewController {

    private func setupSearchController() {
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

        searchViewModel.selectedPlaceSubject
            .sink { [weak self] place in    // TODO: a little ugly
                self?.searchController.dismiss(animated: true)

                // clear out search
                self?.searchController.searchBar.text = nil
                self?.searchController.searchBar.searchTextField.text = nil

                // store in user defaults
                self?.weatherViewModel.selectedPlace = place

                self?.activityIndicator.startAnimating()
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
