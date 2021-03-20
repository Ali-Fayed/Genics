//
//  IssuesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import JGProgressHUD

class IssuesViewController: UIViewController {
    
    var pageNo : Int = 1
    var totalPages : Int = 100
    var issuesData = [Issue]()
    let spinner = JGProgressHUD(style: .dark)
     let footer = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    var search = UISearchController(searchResultsController: nil)

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Search Issues"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footer
        searchIssues ()
        view.addSubview(searchLabel)
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        tableView.addSubview(refreshControl)
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == false {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }
    }
    
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == false {
                self.search.searchBar.becomeFirstResponder()
            }
        }
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    func searchIssues () {
            spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, "a"), pagination: false) { [weak self] (result) in
            self?.issuesData = result.items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.dismiss()
            }
        }
    }

}

