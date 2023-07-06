//
//  ViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit
import Combine

// ICONS
// https://openweathermap.org/img/wn/{icon}@2x.png
// for caching, icon responses include ETag, last-modified and cache-control: max-age

let OPENWEATHER_APP_ID = ""

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
    private lazy var formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherStackView.isHidden = true

        setupSearchController()

        weatherViewModel.$weather
            .sink { completion in
                print("weather completed")
            } receiveValue: { [weak self] weather in
                guard let weather = weather else { return }
                print("received: \(weather)")

                self?.populateContent(for: weather)
            }
            .store(in: &subscriptions)
    }

    // TODO: move formatting to view model
    func populateContent(for weather: WeatherModel) {
        placeLabel.text = weather.title
        currentTempLabel.text = "\(weather.currentTemperature)º F"
        conditionLabel.text = weather.currentConditions
        highTempLabel.text = {
            guard let max = weather.maximumTemperature else { return nil }
            return "HI: \(max)º F"
        }()
        lowTempLabel.text = {
            guard let min = weather.minimumTemperature else { return nil }
            return "LO: \(min)º F"
        }()
        humidityLabel.text = "Humidity: \(weather.humidity)%"
        feelsLikeLabel.text = {
            guard let feelsLike = weather.feelsLike else { return nil }
            return "Feels Like: \(feelsLike)º F"
        }()
        sunriseLabel.text = {
            guard let sunrise = weather.sunrise else { return nil }
            return "Sunrise: \(formatter.string(from: Date(timeIntervalSince1970: sunrise)))"
        }()
        sunsetLabel.text = {
            guard let sunset = weather.sunset else { return nil }
            return "Sunset: \(formatter.string(from: Date(timeIntervalSince1970: sunset)))"
        }()
/*
        iconImageView.image = {

        }()
*/
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
            .sink { [weak self] place in
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
