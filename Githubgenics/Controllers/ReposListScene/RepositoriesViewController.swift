//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import JGProgressHUD

class RepositoriesViewController: ViewSetups {
    
    // data models
    var publicRepositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    var pageNo : Int = 1
    var totalPages : Int = 100
    var query : String = "a"
    // two search bar for animating (check search bar page)
    lazy var reposSearchBar:UISearchBar = UISearchBar()
//    lazy var repoSearchBarHeader:UISearchBar = UISearchBar()

     var searchController = UISearchController(searchResultsController: nil)

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
        // search label subview
        view.addSubview(noContentLabel)
        // hide label and zero opacity when start
        noContentLabel.text = Titles.searchForRepos
        noContentLabel.isHidden = true
        noContentLabel.alpha = 0.0
        tableView.tableFooterView = UIView()
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
           setupSearchBar(search: searchController)
            renderAndDisplayBestSwiftRepositories ()
            navigationItem.title = Titles.repositoriesViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.title = "Results"
            self.searchRepositories(query: query, page: pageNo)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = true
    }
        
    // layout and framing
    override func viewDidLayoutSubviews() {
        noContentLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
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
    
    
}
