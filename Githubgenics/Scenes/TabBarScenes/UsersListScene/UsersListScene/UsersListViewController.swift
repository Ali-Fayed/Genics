//
//  UsersListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire
import JGProgressHUD


class UsersListViewController: UIViewController  {
    
    // data models
    var usersModel = [items]()
    var passedUsers : items?
    var lastSearch = [LastSearch]()
    // page number for requests
    var pageNo : Int = 1
    var totalPages : Int = 100
    // pagination checking var
    var isPaginating = false
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // two searchBars for realtime location changing "explained in searchBarPage Code"
    lazy var searchBar = UISearchBar()
    lazy var usersListViewSearchBar = UISearchBar()
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
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register cell with transfer class to identifier string
        tableView.registerCellNib(cellClass: UsersCell.self)
        // Tab bar config
        self.tabBarController?.navigationItem.title = Titles.usersViewTitle
        tabBarController?.navigationItem.hidesBackButton = true
        title = Titles.usersViewTitle
        tableView.tableHeaderView = self.usersListViewSearchBar
        // Subviews
        view.addSubview(searchLabel)
        tableView.addSubview(refreshControl)
        searchLabel.isHidden = true
        // Zero opacity
        searchLabel.alpha = 0.0
        historyView.alpha = 0.0
        searchBar.alpha = 0.0
        // Render searchbar
        renderSearchBar()
        // API Requset to fetch Users
        renderUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.usersViewTitle
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
     // Layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    
    //MARK:- Functions
    
    // fetch users in list
    func renderUsersList  ()  {
        //check for pagination bool
        guard !isPaginating else {
            return
        }
        spinner.show(in: view)
        GitAPIManger().fetchUsers(query: "m", page: pageNo, pagination: false ) { [weak self] users in
            guard ((self?.usersModel = users) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if self?.searchBar.showsCancelButton == false {
                    self?.skeletonViewLoader()
                    self?.spinner.dismiss()
                }
            }
        }
    }

    // fetch more users
    func fetchMoreUsers () {
        // next page every call
        if  pageNo < totalPages {
            pageNo += 1
            // check for pagination bool
            guard !isPaginating else {
                return
            }
            // pagination when search and without in same view
            let querySetup : String = {
                var query : String = "a"
                if searchBar.text == nil {
                    query = searchBar.text ?? ""
                }
                return query
            }()
            // pagination and view next page
            GitAPIManger().fetchUsers(query: querySetup, page: pageNo, pagination: true ) { [weak self] result in
                guard ((self?.usersModel.append(contentsOf: result)) != nil) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                    HapticsManger.shared.selectionVibrate(for: .light)
                }
            }
        }
    }
    
    // search for user
    func searchUser (query: String) {
        GitAPIManger().fetchUsers(query: query, page: 1) { [weak self] users in
            guard ((self?.usersModel = users) != nil) else {
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // Handle Refresh
        
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    // UI Methods
    
    func skeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    func renderSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Titles.searchPlacholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        usersListViewSearchBar.searchBarStyle = UISearchBar.Style.prominent
        usersListViewSearchBar.placeholder = Titles.searchPlacholder
        usersListViewSearchBar.sizeToFit()
        usersListViewSearchBar.isTranslucent = false
        usersListViewSearchBar.delegate = self
    }

}
