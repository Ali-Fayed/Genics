//
//  SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/03/2021.
//

import UIKit
import JGProgressHUD
import XCoordinator

class CommonViews : UIViewController {

    let tableFooterView = UIView()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    func dismissButton() {
       let button = UIButton(type: .system)
       button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
       button.setTitle("Back", for: .normal)
       button.sizeToFit()
       button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
       let backButton = UIBarButtonItem(customView: button)
       navigationItem.leftBarButtonItem = backButton
   }
    @objc func dismissView () {
//        viewModel.router?.trigger(.dismiss)
    }
    // searchLabel appear before searching
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
    
    func showTableViewSpinner (tableView: UITableView) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    func reloadTableViewData(tableView: UITableView, tableView1: UITableView?, tableView2: UITableView?) {
        tableView.reloadData()
        tableView1?.reloadData()
        tableView2?.reloadData()
    }
    
}
