//
//  UsersListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire

class UsersListViewController: UIViewController  {
    
    var users = [items]()
    var passedusers : items?
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var pageNo : Int = 1
    var totalPages : Int = 100
    var isPaginating = false
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let longPress = UILongPressGestureRecognizer()
    lazy var searchBar = UISearchBar()
    lazy var listSearchBar = UISearchBar()
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(UsersListViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cells.usersNib(), forCellReuseIdentifier: Cells.usersCell)
        tableView.addGestureRecognizer(longPress)
        tableView.addSubview(refreshControl)
        tableView.tableHeaderView = self.listSearchBar
        tabBarController?.navigationItem.hidesBackButton = true
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        historyView.alpha = 0.0
        searchBar.alpha = 0.0
        renderSearchBar()
        renderUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.usersViewTitle
        navigationController?.isNavigationBarHidden = false
        self.searchBar.becomeFirstResponder()
        self.historyView.alpha = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.usersViewTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.historyView.alpha = 0.0
        self.tableView.reloadData()
    }
}
