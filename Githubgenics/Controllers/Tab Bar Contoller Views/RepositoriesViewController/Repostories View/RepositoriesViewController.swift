//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class RepositoriesViewController: UITableViewController {
    
    lazy var listSearchBar:UISearchBar = UISearchBar()
    lazy var listSearchBar2:UISearchBar = UISearchBar()
    let longPress = UILongPressGestureRecognizer()
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var repositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isLoggedIn: Bool {
      if TokenManager.shared.fetchAccessToken() != nil {
        return true
      }
      return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.addGestureRecognizer(longPress)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.register(Cells.reposNib(), forCellReuseIdentifier: Cells.repositoriesCell)
        tableView.rowHeight = 120
        self.tabBarItem.title = Titles.RepositoriesViewTitle
        renderSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableHeaderView = self.listSearchBar2
        self.tabBarController?.tabBar.isHidden = false
        if isLoggedIn {
            renderAndDisplayUserRepositories ()
        } else {
          renderAndDisplayBestSwiftRepositories ()
        }
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
