//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class RepositoriesViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var listSearchBar:UISearchBar = UISearchBar()
    lazy var listSearchBar2:UISearchBar = UISearchBar()
    let longPress = UILongPressGestureRecognizer()
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var repositories : [Repository] = []
    var rep : [Repositories] = []
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    var starButton = [Int : Bool]()
    var isLoggedIn: Bool {
      if TokenManager.shared.fetchAccessToken() != nil {
        return true
      }
      return false
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.addGestureRecognizer(longPress)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.rowHeight = 60
        self.tabBarItem.title = Titles.RepositoriesViewTitle
        renderSearchBar()
        renderStarState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableHeaderView = self.listSearchBar2
        self.tabBarController?.tabBar.isHidden = false
        renderAndDisplayBestSwiftRepositories ()
        tabBarController?.navigationItem.rightBarButtonItem = nil

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.tableHeaderView = self.listSearchBar2
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
    }
    
}