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

class UsersViewController: ViewSetups  {
    
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
    
    // Layout and framing
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- UI Functions
    
    
    func initView () {
        tabBarItem.title = Titles.usersViewTitle
        conditionLabel.text = Titles.searchForUsers
        renderRecentHistoryHiddenConditions()
        handleHidden ()
        handleSubViews ()
        handleTableViews ()
        
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
    
    func initViewModel () {
        viewModel.recentSearchData(collectionView: collectionView, tableView: tableView)
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.renderUsersList(tableView: tableView, searchController: searchController, loadingSpinner: loadingSpinner)
        } else {
            viewModel.renderPassedQuerySearch(query: query, tableView: tableView, loadingSpinner: loadingSpinner)
        }
    }
    
    func handleHidden () {
        conditionLabel.isHidden = true
        recentSearchTable.isHidden = true
    }
    
    func handleSubViews () {
        tableView.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)
        view.addSubview(conditionLabel)
    }
    
    func handleTableViews () {
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.tableFooterView = tableFooterView
        recentSearchTable.tableFooterView = tableFooterView
    }
            
    func renderRecentHistoryHiddenConditions () {
        if recentSearchTable.isHidden == true {
            conditionLabel.isHidden = false
        } else {
            conditionLabel.isHidden = true
        }
    }
}
