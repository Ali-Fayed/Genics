//
//  HomeViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import SwiftyJSON
import SafariServices

class HomeViewController: ViewSetups {
    
    var searchHistory = [SearchHistory]()
    var profileTableData = [ProfileTableData]()
    var searchTableData = [ProfileTableData]()
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searchFieldsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.homeViewTitle
        tabBarItem.title = Titles.homeViewTitle
        
        historyTable.isHidden = true
        conditionLabel.isHidden = true
        searchFieldsTable.isHidden = true
        
        setupSearchController(search: searchController)
        searchController.searchBar.delegate = self
        tableView.addSubview(refreshControl)
        
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.searchGithub
        
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "Profile"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", Image: "Issues"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.gitHubURL)", Image: "GithubWeb"))
        
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "peoples"))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "repoSearch" ))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", Image: "issue"))
        
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        historyTable.reloadData()
        searchFieldsTable.reloadData()
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}
