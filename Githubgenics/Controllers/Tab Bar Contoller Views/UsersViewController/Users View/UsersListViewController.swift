//
//  UsersListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire

class UsersListViewController: UIViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let longPress = UILongPressGestureRecognizer()
    var users = [items]()
    var passedusers :items?
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var pageNo :Int = 1
    var totalPages:Int = 100
    var isPaginating = false
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
        fetchUsersList()
        tableView.addGestureRecognizer(longPress)
        self.tableView.addSubview(refreshControl)
        tableView.register(Cells.usersNib(), forCellReuseIdentifier: Cells.usersCell)
        self.tabBarController?.navigationItem.hidesBackButton = true
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        renderSearchBar()
        self.tableView.tableHeaderView = self.listSearchBar
        self.historyView.alpha = 0.0
        self.searchBar.alpha = 0.0
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
