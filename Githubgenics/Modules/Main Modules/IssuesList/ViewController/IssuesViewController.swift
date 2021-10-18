//
//  IssuesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import JGProgressHUD

class IssuesViewController: CommonViews {
    
    var query: String = ""
    @IBOutlet weak var tableView: UITableView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: IssuesViewModel = {
       return IssuesViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if self.searchController.searchBar.text?.isEmpty == false {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView() {
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            self.navigationItem.searchController = searchController
            title = Titles.issuesViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
        tableView.tableFooterView = tableFooterView
        conditionLabel.text = Titles.searchIssues
        view.addSubview(conditionLabel)
    }
    
    func initViewModel() {
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.searchIssues(tableView: tableView, loadingSpinner: loadingSpinner, view: view)
        } else {
            viewModel.passedSearchIssues(tableView: tableView, loadingSpinner: loadingSpinner, view: view, query: query)
        }
    }
}
