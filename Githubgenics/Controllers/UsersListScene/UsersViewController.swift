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

class UsersViewController: UIViewController  {
    
    // data models
    var searchHistory = [SearchHistory]()
    var usersModel = [items]()
    var savedUsers = [UsersDataBase]()
    var passedUsers : items?
    var lastSearch = [LastSearch]()
    // page number for requests
    var pageNo : Int = 1
    var totalPages : Int = 100
    let footer = UIView()
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let spinner = JGProgressHUD(style: .dark)
    // refresh table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // searchLabel appear before searching
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForUsers
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
     var search = UISearchController(searchResultsController: nil)
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
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == false {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }
        recentSearchData ()
        navigationItem.title = Titles.usersViewTitle
        tabBarItem.title = Titles.usersViewTitle
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)

        tableView.tableFooterView = footer
        recentSearchTable.tableFooterView = footer
        // Hiding
        recentSearchTable.isHidden = true
        view.addSubview(searchLabel)
        renderRecentHistoryHiddenConditions()
        searchLabel.isHidden = true
        // Rendering
        renderUsersList()
    }
    
    func recentSearchData () {
        DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
            self?.lastSearch = result
            self?.collectionView.reloadData()
            DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                self?.searchHistory = result
//                self?.recentSearchTable.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == false {
                self.search.searchBar.becomeFirstResponder()
            }
        }
    }
    
    // Layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Functions
    
    // fetch users in table
    func renderUsersList ()  {
        spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(pageNo, "R")) { [weak self] (users) in
            DispatchQueue.main.async {
                self?.usersModel = users.items
                self?.tableView.reloadData()
                if self?.search.searchBar.showsCancelButton == false {
                    self?.spinner.dismiss()
                }
            }
        }
    }
    
    // Handle Refresh
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
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
                self.searchLabel.isHidden = false
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
            searchLabel.isHidden = false
        } else {
            searchLabel.isHidden = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}
