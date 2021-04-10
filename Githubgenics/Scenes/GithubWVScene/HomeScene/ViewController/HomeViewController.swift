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
        
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var searchOptionsTableView: UITableView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView ()
        initViewModel ()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistoryTableView.reloadData()
        reloadTableViewData(tableView: homeTableView, tableView1: searchHistoryTableView, tableView2: searchOptionsTableView)
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView () {
        title = Titles.homeViewTitle
        tabBarItem.title = Titles.homeViewTitle
        conditionLabel.text = Titles.searchGithub
        setupSearchController(search: searchController)
        homeTableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        searchController.searchBar.delegate = self
        searchHistoryTableView.isHidden = true
        searchOptionsTableView.isHidden = true
        conditionLabel.isHidden = true
    }
    
    func initViewModel  () {
        viewModel.initHomeTableCellData ()
        viewModel.initSearchOptionsTableCellData()
        viewModel.initLocalDataBaseCellData ()
    }
    
}
