//
//  SearchViewModel.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/5/23.
//

import CoreLocation
import UIKit
import Combine

struct Place: Sendable {
    let name: String
    let coordinate: Coordinate
}

struct Coordinate: Sendable {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    init(from location: CLLocation) {
        self.init(from: location.coordinate)
    }

    init(from coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

class SearchViewModel: NSObject {

    let selectedPlaceSubject = PassthroughSubject<Place, Never>()

    private(set) var dataSource: UITableViewDiffableDataSource<Int, CLPlacemark>?

    func initializeDataSource(using tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, placemark in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCellID",
                                                     for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = placemark.cellText
            cell.contentConfiguration = content
            return cell
        }
    }

    private func updateTableView(with placemarks: [CLPlacemark]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CLPlacemark>()
        snapshot.appendSections([0])
        snapshot.appendItems(placemarks)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let placemark = dataSource!.itemIdentifier(for: indexPath) else {
            fatalError("dataSource is nil or no CLPlacemark could be found")
        }

        guard let location = placemark.location else {
            fatalError("unexpected: missing latitude/longitude")
        }

        let place = Place(name: placemark.titleText,
                          coordinate: Coordinate(from: location))
        selectedPlaceSubject.send(place)
    }
}

extension SearchViewModel: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        let trimmedText = text.trimmingCharacters(in: .whitespaces)

        // ensure at least 3 characters typed
        guard trimmedText.count > 2 else { return }

        let geocoder = CLGeocoder()
        geocoder.cancelGeocode()

        Task.detached(priority: .userInitiated) { [unowned self] in
            let placemarks = try await geocoder.geocodeAddressString(trimmedText)
            await MainActor.run {
                updateTableView(with: placemarks)
            }
        }
    }
}

private extension CLPlacemark {
    var cellText: String {
        [name, locality, postalCode, administrativeArea, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }

    var titleText: String {
        return name ?? locality ?? "Unknown"
    }
}
