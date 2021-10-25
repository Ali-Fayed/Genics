//
//  SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/03/2021.
//

import UIKit
import JGProgressHUD
import XCoordinator


class CommonViews: UIViewController {

    let tableFooterView = UIView()
    let loadingSpinner = JGProgressHUD(style: .dark)
    var pageNo : Int = 1
    var totalPages : Int = 100
    // refresh table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    // Handle Refresh
    @objc func refreshTable(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    func setupSearchController (search: UISearchController) {
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        navigationItem.searchController = search
    }
    func reloadTableViewData(tableView: UITableView, tableView1: UITableView?, tableView2: UITableView?) {
        tableView.reloadData()
        tableView1?.reloadData()
        tableView2?.reloadData()
    }
 
}
