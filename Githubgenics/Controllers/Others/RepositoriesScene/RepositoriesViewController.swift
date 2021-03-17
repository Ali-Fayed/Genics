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
    var pageNo : Int = 1
    var totalPages : Int = 100
    // two search bar for animating (check search bar page)
    lazy var reposSearchBar:UISearchBar = UISearchBar()
//    lazy var repoSearchBarHeader:UISearchBar = UISearchBar()
    let spinner = JGProgressHUD(style: .dark)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
     var search = UISearchController(searchResultsController: nil)
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
        title = Titles.repositoriesViewTitle
        tabBarItem.title = Titles.repositoriesViewTitle
        // tableview
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = 60
        // search label subview
        view.addSubview(searchLabel)
        // hide label and zero opacity when start
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        tableView.tableFooterView = UIView()
        renderAndDisplayBestSwiftRepositories ()
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == false {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
            if self.search.searchBar.text?.isEmpty == false {
                self.search.searchBar.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = true
    }
        
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Functions
    
    // Fetch Methods
    func searchRepositories (query: String, page: Int) {
        if publicRepositories.isEmpty {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(page, query)) { [weak self] (repositories) in
            self?.publicRepositories = repositories.items
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func fetchMoreRepositories (query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(page, query), pagination: true) { [weak self]  (moreRepos) in
            DispatchQueue.main.async {
                if moreRepos.items.isEmpty == false {
                    self?.publicRepositories.append(contentsOf: moreRepos.items)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = nil
                }
            }
        }
    }
    
    // UI Methods
    func renderAndDisplayBestSwiftRepositories() {
        if publicRepositories.isEmpty {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(pageNo, "language:Swift")) { [weak self] (repos) in
            self?.publicRepositories = repos.items
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    
}
