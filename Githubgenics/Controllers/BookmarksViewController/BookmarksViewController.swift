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
    // longpress
    let longPress = UILongPressGestureRecognizer()
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
     // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.addGestureRecognizer(longPress)
        tableView.addSubview(refreshControl)
        // footer to remove unused seprators
        tableView.tableFooterView = UIView()
        // hide label and zero opacity
        view.addSubview(searchLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        // title
        self.tabBarController?.navigationItem.title = Titles.BookmarksViewTitle
        // fetch bookmarks
        renderViewData ()
        // searchbar
        searchBar.placeholder = Titles.searchPlacholder
        renderSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.BookmarksViewTitle
        tabBarController?.navigationItem.rightBarButtonItem = nil
        renderViewData ()
    }
    
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
}
