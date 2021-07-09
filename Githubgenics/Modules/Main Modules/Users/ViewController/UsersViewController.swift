//
//  UsersViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire
import JGProgressHUD
import CoreData

class UsersViewController: ViewSetups {
    
    var query : String = ""
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: UsersViewModel = {
       return UsersViewModel()
   }()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    
    @IBAction func removeAll(_ sender: UIButton) {
        viewModel.excute(tableView: recentSearchTable, collectionView: collectionView, label: conditionLabel)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        recentSearchTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.becomeFirstResponder()
        
    }
    
    // Layout and framing
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- UI Functions
    
    func initView () {
        tabBarItem.title = Titles.usersViewTitle
        conditionLabel.text = Titles.searchForUsers
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        recentSearchTable.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.isHidden = true
        recentSearchTable.isHidden = true
        handleViewStyle ()
        renderRecentHistoryHiddenConditions()
    }
    
    func initViewModel () {
        viewModel.recentSearchData(collectionView: collectionView, tableView: recentSearchTable)
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: "a")
        } else {
            viewModel.fetchUsers(tableView: self.tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: query)
        }
    }
            
    func renderRecentHistoryHiddenConditions () {
        if recentSearchTable.isHidden == true , searchController.searchBar.text?.isEmpty == false {
            conditionLabel.isHidden = false
        } else {
            conditionLabel.isHidden = true
        }
        
        if viewModel.lastSearch.isEmpty == true , viewModel.searchHistory.isEmpty == true {
            conditionLabel.isHidden = true
        }
    }
    
    func handleViewStyle () {
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            title = Titles.usersViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
    }
}
