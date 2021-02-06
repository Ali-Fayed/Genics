//
//  RepositoriesListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class RepositoriesViewController: UITableViewController {
    var repositories: [Repository] = []
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    lazy var listSearchBar:UISearchBar = UISearchBar()
    lazy var listSearchBar2:UISearchBar = UISearchBar()

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: K.repositoriesCell)
        tableView.rowHeight = 120
        fetchAndDisplayUserRepositories()
        viewSearchBar()
//        tabBarController?.navigationItem.titleView = self.listSearchBar
//        tabBarController?.navigationItem.titleView?.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableHeaderView = self.listSearchBar2
        self.tabBarController?.tabBar.isHidden = false


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = loginButton
        loginButton?.title = "Login".localized()
        self.tabBarController?.navigationItem.title = "Repositories".localized()
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.tableHeaderView = self.listSearchBar2
//        if let searchText = searchBar.text, !searchText.isEmpty {
//            return
//        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
        
    }
    
    func fetchAndDisplayUserRepositories() {
      loadingIndicator.startAnimating()
        GitAPIManager.shared.fetchUserRepositories { [self] repositories in
        self.repositories = repositories
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }
    }
    
    func viewSearchBar() {
        listSearchBar.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar.placeholder = "Search Repositories ..."
        listSearchBar.sizeToFit()
        listSearchBar.isTranslucent = false
        listSearchBar.delegate = self
        listSearchBar2.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar2.placeholder = "Search Repositories ..."
        listSearchBar2.sizeToFit()
        listSearchBar2.isTranslucent = false
        listSearchBar2.delegate = self
    }
    
}






