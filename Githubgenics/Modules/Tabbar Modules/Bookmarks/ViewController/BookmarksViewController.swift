//
//  BookmarksViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit
import CoreData

class BookmarksViewController: ViewSetups {
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: BookmarksViewModel = {
        return BookmarksViewModel ()
    }()
    // before search label
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForBookmarks
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        initViewModel()
        viewModel.noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
 
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView() {
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        conditionLabel.text = Titles.noBookmarks
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        setupSearchController(search: searchController)
        view.addSubview(searchLabel)
        view.addSubview(conditionLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        viewModel.noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    
    func initViewModel() {
        viewModel.renderViewData(tableView: tableView)
    }

}
