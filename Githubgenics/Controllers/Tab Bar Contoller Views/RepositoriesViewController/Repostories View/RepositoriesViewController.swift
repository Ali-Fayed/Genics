//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class RepositoriesViewController: UITableViewController {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var repositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    lazy var listSearchBar:UISearchBar = UISearchBar()
    lazy var listSearchBar2:UISearchBar = UISearchBar()
    @IBOutlet weak var searchBar: UISearchBar!
    let longPress = UILongPressGestureRecognizer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.addGestureRecognizer(longPress)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.register(Cells.reposNib(), forCellReuseIdentifier: Cells.repositoriesCell)
        tableView.rowHeight = 120
        renderAndDisplayUserRepositories()
        renderSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableHeaderView = self.listSearchBar2
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.tableHeaderView = self.listSearchBar2
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
    }
    
}
