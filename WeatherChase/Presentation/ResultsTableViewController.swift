//
//  SearchResultsViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit
import Combine
import CoreLocation // TODO: remove to ViewModel or similar

class ResultsTableViewController: UITableViewController {

    var placemarks: [CLPlacemark] = []  {
        didSet {
            tableView.reloadData()
        }
    }

    let selectedLocationSubject = PassthroughSubject<CLLocation, Never>()

//    private weak var weatherViewModel: WeatherViewModel?
//    private let searchViewModel = SearchViewModel()

    // MARK:  TableView Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchViewModel.placemarks.count
        return placemarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCellID", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let placemark = placemarks[indexPath.item] // TODO: indexOutOfBounds
        content.text = rowString(from: placemark)
        cell.contentConfiguration = content

        return cell
    }

    private func rowString(from placemark: CLPlacemark) -> String {
        let placemarkDetails = [placemark.name,
                                placemark.locality, // city
                                placemark.postalCode,
                                placemark.administrativeArea, // state/province
                                placemark.country]
        return placemarkDetails.compactMap { $0 }
            .joined(separator: ", ")
    }

    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = placemarks[indexPath.item]   // TODO: indexOutOfBounds
        guard let location = placemark.location else {
            fatalError("unexpected: missing latitude/longitude") // TODO:
        }

        selectedLocationSubject.send(location)

        dismiss(animated: true)
    }
}
