//
//  BookmarksViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    // data models
    var savedRepositories = [SavedRepositories]()
    var bookmarkedUsers = [UsersDataBase]()
    var passedRepo : SavedRepositories?
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // searchBar
    lazy var searchRepositoriesBar:UISearchBar = UISearchBar()
    lazy var searchBarHeader:UISearchBar = UISearchBar()
    // refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // before search label
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForSaved
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    let noBookmarksLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noBookmarks
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
     // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        // tableview
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        // hide label and zero opacity
        view.addSubview(searchLabel)
        view.addSubview(noBookmarksLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        // fetch bookmarks
        renderViewData ()
        // searchbar
        searchBar.placeholder = Titles.searchPlacholder
        renderSearchBar()
        noBookmarksState ()
        navigationItem.titleView = nil
        searchRepositoriesBar.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchRepositoriesBar.becomeFirstResponder()
        title = Titles.bookmarksViewTitle
        renderViewData ()
        noBookmarksState ()
    }
    
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        noBookmarksLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Fetch Methods
    
    // fetch
    func renderViewData () {
        DataBaseManger.shared.Fetch(returnType: UsersDataBase.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            self?.tableView.reloadData()
        }
        DataBaseManger.shared.Fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.savedRepositories = reps
            self?.tableView.reloadData()
        }
    }
    
    // refresh
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    // search
    func renderSearchBar() {
        searchRepositoriesBar.searchBarStyle = UISearchBar.Style.prominent
        searchRepositoriesBar.placeholder = Titles.searchPlacholder
        searchRepositoriesBar.sizeToFit()
        searchRepositoriesBar.delegate = self
        searchBarHeader.searchBarStyle = UISearchBar.Style.prominent
        searchBarHeader.placeholder = Titles.searchPlacholder
        searchBarHeader.sizeToFit()
        searchBarHeader.delegate = self
    }
    
    func noBookmarksState () {
        if bookmarkedUsers.isEmpty == true , savedRepositories.isEmpty == true {
            noBookmarksLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noBookmarksLabel.isHidden = true
            tableView.isHidden = false
        }
    }
}
