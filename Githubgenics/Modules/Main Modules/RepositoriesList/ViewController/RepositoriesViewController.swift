//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import JGProgressHUD

class RepositoriesViewController: ViewSetups {

    var query : String = ""
    lazy var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: ReposViewModel = {
       return ReposViewModel()
   }()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
        
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView () {
        conditionLabel.text = Titles.searchForRepos
        conditionLabel.isHidden = true
        conditionLabel.alpha = 0.0
        tableView.tableFooterView = UIView()
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        title = Titles.repositoriesViewTitle
        tabBarItem.title = Titles.repositoriesViewTitle
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
           setupSearchController(search: searchController)
            navigationItem.title = Titles.repositoriesViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
    }
    
    func initViewModel () {
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.renderAndDisplayBestSwiftRepositories(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
        } else {
            viewModel.searchRepositories(tableView: tableView, loadingSpinner: loadingSpinner, query: query, page: pageNo, view: view)
        }
    }

}
