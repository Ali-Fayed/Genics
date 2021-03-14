//
//  UsersViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Alamofire
import JGProgressHUD

class UsersViewController: UIViewController  {
    
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
        navigationItem.title = Titles.usersViewTitle
        tabBarItem.title = Titles.usersViewTitle
        view.addSubview(searchLabel)
        // register cell with transfer class to identifier string
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.tableHeaderView = self.usersListViewSearchBar
        tableView.rowHeight = 60
        tableView.addSubview(refreshControl)
        // Hiding
        searchLabel.alpha = 0.0
        historyView.alpha = 0.0
        searchBar.alpha = 0.0
        searchLabel.isHidden = true
        // Rendering
        renderSearchBar()
        renderUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        searchBar.text = nil
    }
    
    // Layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Functions
    
    // fetch users in table
    func renderUsersList ()  {
        spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequsetRouter.gitPublicUsers(pageNo, "m")) { [weak self] (users) in
            DispatchQueue.main.async {
                self?.usersModel = users.items
                self?.tableView.reloadData()
                if self?.searchBar.showsCancelButton == false {
                    self?.tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    }
                    self?.spinner.dismiss()
                }
            }
        }
    }
    
    // fetch more users
    func fetchMoreUsers (query: String, page: Int) {
        guard !isPaginating else {
            return
        }
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequsetRouter.gitPublicUsers(page, query), pagination: true) { [weak self]  (moreUsers) in
            DispatchQueue.main.async {
                self?.usersModel.append(contentsOf: moreUsers.items)
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
        }
    }
    
    // Handle Refresh
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    func renderSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Titles.searchPlacholder
        searchBar.sizeToFit()
        searchBar.delegate = self
        usersListViewSearchBar.searchBarStyle = UISearchBar.Style.default
        usersListViewSearchBar.placeholder = Titles.searchPlacholder
        usersListViewSearchBar.sizeToFit()
        usersListViewSearchBar.delegate = self
    }
    
}
