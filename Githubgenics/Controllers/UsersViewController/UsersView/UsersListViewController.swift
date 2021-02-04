//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit

class UsersListViewController: UIViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let longPress = UILongPressGestureRecognizer()
    var users : [items] = []
    var moreUsers : [items] = []
   lazy var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var isPaginating = false
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(UsersListViewController.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
            return refreshControl
        }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            
        refreshList ()
        refreshControl.endRefreshing()
        }
    
    lazy var searchBar:UISearchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var signOutButton: UIBarButtonItem?
    @IBAction func refreshTable(_ sender: UIRefreshControl?) {
        sender?.endRefreshing()
        refreshList ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersList()
        tableView.addGestureRecognizer(longPress)
        self.tableView.addSubview(refreshControl)
        signOutButton?.title = "Signout".localized()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundColor = UIColor(named: "ViewsColorBallet")
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.title = "Users".localized()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil

    }
    
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        performSignOut ()
    }
}
