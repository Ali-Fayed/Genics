//
//  UsersListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire


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
    
    let longPress = UILongPressGestureRecognizer()
    // two searchBars for realtime location changing "explained in searchBarPage Code"
    lazy var searchBar = UISearchBar()
    lazy var usersListViewSearchBar = UISearchBar()
    // loadingIndicator var
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
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
        // tab bar config
        self.tabBarController?.navigationItem.title = Titles.usersViewTitle
        tabBarController?.navigationItem.hidesBackButton = true
        tableView.tableHeaderView = self.usersListViewSearchBar
        // subviews
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        view.addSubview(searchLabel)
        tableView.addSubview(refreshControl)
        tableView.addGestureRecognizer(longPress)
        searchLabel.isHidden = true
        // zero opacity
        searchLabel.alpha = 0.0
        historyView.alpha = 0.0
        searchBar.alpha = 0.0
        // render searchbar
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
    
}
