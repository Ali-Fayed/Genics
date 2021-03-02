//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import JGProgressHUD

class RepositoriesViewController: UIViewController {
    
    // data models
    var publicRepositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    // two search bar for animating (check search bar page)
    lazy var reposSearchBar:UISearchBar = UISearchBar()
    lazy var repoSearchBarHeader:UISearchBar = UISearchBar()
    let spinner = JGProgressHUD(style: .dark)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        label.text = Titles.searchForRepos
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.rowHeight = 60
        // search label subview
        view.addSubview(searchLabel)
        tableView.addSubview(refreshControl)
        // hide label and zero opacity when start
        searchLabel.isHidden = true
        self.searchLabel.alpha = 0.0
        // title and seachbar
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        renderSearchBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // return tab bar after search
        self.tabBarController?.tabBar.isHidden = false
        // main screen repos
        renderAndDisplayBestSwiftRepositories ()
        title = Titles.RepositoriesViewTitle

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.tableHeaderView = self.repoSearchBarHeader
        tableView.tableFooterView = UIView()
        tabBarController?.navigationItem.rightBarButtonItem = nil
        title = Titles.RepositoriesViewTitle

    }

    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Functions
    
    // Fetch Methods
    func searchRepositories (query: String) {
        if publicRepositories.isEmpty {
            spinner.show(in: view)
        }
        GitAPIManger().searchPublicRepositories(query: query) { [weak self] repositories in
            self?.publicRepositories = repositories
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    // UI Methods
    func renderAndDisplayBestSwiftRepositories() {
        if publicRepositories.isEmpty {
            spinner.show(in: view)
        }
        GitAPIManger().fetchPopularSwiftRepositories { [weak self] repositories in
            self?.publicRepositories = repositories
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    // Searchbar
    func renderSearchBar() {
        reposSearchBar.searchBarStyle = UISearchBar.Style.prominent
        reposSearchBar.placeholder = Titles.searchPlacholder
        reposSearchBar.sizeToFit()
        reposSearchBar.isTranslucent = false
        reposSearchBar.delegate = self
        repoSearchBarHeader.searchBarStyle = UISearchBar.Style.prominent
        repoSearchBarHeader.placeholder = Titles.searchPlacholder
        repoSearchBarHeader.sizeToFit()
        repoSearchBarHeader.isTranslucent = false
        repoSearchBarHeader.delegate = self
    }
    
}
