//
//  HomeViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import SwiftyJSON
import SafariServices

class HomeViewController: UIViewController {
    
    var searchHistory = [SearchHistory]()
    var profileTableData = [ProfileTableData]()
    var searchTableData = [ProfileTableData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Search Github"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searchFieldsTable: UITableView!

    
     var search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTable.isHidden = true
        self.searchLabel.isHidden = true
        self.searchFieldsTable.isHidden = true
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
        search.searchBar.placeholder = Titles.searchPlacholder
        self.navigationItem.searchController = search
        tableView.addSubview(refreshControl)
        view.addSubview(searchLabel)
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "Profile"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Issues)", Image: "Issues"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.commitsViewTitle)", Image: "Startted" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.Organizations)", Image: "Organizations"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.gitHubURL)", Image: "GithubWeb"))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "peoples"))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "repoSearch" ))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.Issues)", Image: "issue"))
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }

}
