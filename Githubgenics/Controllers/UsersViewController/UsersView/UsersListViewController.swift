//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire


class UsersListViewController: UIViewController  {
    var pageNo :Int = 1
    var totalPages:Int = 100

//    let querySetup : String = {
//          var query : String = "a"
//        if searchBar.text == nil {
//            query = searchBar.text ?? ""
//        } else {
//            self.searchBar.text = "a"
//        }
//        return query
//    }()

    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let longPress = UILongPressGestureRecognizer()
    var users : [items] = []
    var passedusers :items?
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var isPaginating = false
     var refreshControl: UIRefreshControl = {
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
   lazy var listSearchBar:UISearchBar = UISearchBar()

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
        tableView.register(UsersCell.nib(), forCellReuseIdentifier: K.usersCell)
        signOutButton?.title = "Signout".localized()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        viewSearchBar()
        self.tableView.tableHeaderView = self.listSearchBar
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton
        self.historyView.alpha = 0.0
        self.searchBar.alpha = 0.0
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        self.searchBar.becomeFirstResponder()
        self.historyView.alpha = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton

        self.tabBarController?.navigationItem.title = "Users".localized()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.historyView.alpha = 0.0
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        performSignOut()
    }
}
