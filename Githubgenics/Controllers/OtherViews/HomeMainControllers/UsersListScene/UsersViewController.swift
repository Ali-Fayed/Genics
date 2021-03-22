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
    
    var searchHistory = [SearchHistory]()
    var usersModel = [items]()
    var savedUsers = [UsersDataBase]()
    var passedUsers : items?
    var lastSearch = [LastSearch]()
    var query : String = "a"
    var searchController = UISearchController(searchResultsController: nil)
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    
    @IBAction func removeAll(_ sender: UIButton) {
        excute ()
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }

    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: UsersCell.self)
        tabBarItem.title = Titles.usersViewTitle
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            renderUsersList()
            title = Titles.usersViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
            GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(1, query)) { [weak self] (searchedUsers) in
                DispatchQueue.main.async {
                    self?.usersModel = searchedUsers.items
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                    self?.loadingSpinner.dismiss()
                }
            }
        }
        recentSearchData ()
        tableView.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.searchForUsers
        tableView.tableFooterView = tableFooterView
        recentSearchTable.tableFooterView = tableFooterView
        renderRecentHistoryHiddenConditions()
        conditionLabel.isHidden = true
        recentSearchTable.isHidden = true

    }
    
    func recentSearchData () {
            DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
                 self?.lastSearch = result
                 self?.collectionView.reloadData()
            DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                 self?.searchHistory = result
                 self?.recentSearchTable.reloadData()
            }
        }
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
    
    //MARK:- Functions
    
    // fetch users in table
    func renderUsersList ()  {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(pageNo, "R")) { [weak self] (users) in
            DispatchQueue.main.async {
                self?.usersModel = users.items
                self?.tableView.reloadData()
                if self?.searchController.searchBar.showsCancelButton == false {
                    self?.loadingSpinner.dismiss()
                }
            }
        }
    }
           
    func excute () {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                self.recentSearchTable.reloadData()
                self.collectionView.reloadData()
                self.recentSearchTable.isHidden = true
                self.conditionLabel.isHidden = false
            }
            DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
                self?.lastSearch = result
                self?.collectionView.reloadData()
            }
                DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                    self?.searchHistory = result
                    self?.recentSearchTable.reloadData()
                }
            } catch {
            //
        }
    }
    
    
    func renderRecentHistoryHiddenConditions () {
        if recentSearchTable.isHidden == true {
            conditionLabel.isHidden = false
        } else {
            conditionLabel.isHidden = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}
