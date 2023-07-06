//
//  SearchResultsViewController.swift
//  WeatherChase
//
//  Created by Kyle Watson on 6/30/23.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    let searchViewModel: SearchViewModel

    init?(coder: NSCoder, viewModel: SearchViewModel) {
        searchViewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("unimplemented method called")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchViewModel.initializeDataSource(using: tableView)

        tableView.dataSource = searchViewModel.dataSource
        tableView.delegate = searchViewModel
    }
}
