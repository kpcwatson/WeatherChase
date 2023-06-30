//
//  SearchResultsViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    let tableViewCellIdentifier = "ResultsCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = "Atlanta, GA US"
        cell.contentConfiguration = content

        return cell
    }

    // delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
