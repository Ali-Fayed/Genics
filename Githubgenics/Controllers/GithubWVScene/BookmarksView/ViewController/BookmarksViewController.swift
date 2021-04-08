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
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        initView()
        noBookmarksState ()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        initViewModel()
        noBookmarksState ()
    }

    func initView() {
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        setupSearchController(search: searchController)
        view.addSubview(searchLabel)
        view.addSubview(conditionLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        conditionLabel.text = Titles.noBookmarks
    }
    
    func initViewModel() {
        viewModel.renderViewData(tableView: tableView)
    }
 
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Fetch Methods
    

    
    func noBookmarksState () {
        if viewModel.bookmarkedUsers.isEmpty == true , viewModel.savedRepositories.isEmpty == true {
            conditionLabel.isHidden = false
            tableView.isHidden = true
        } else {
            conditionLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @IBAction func removeAll(_ sender: UIButton) {
            let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.usersEntity)
            let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.repositoryEntity)
            let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
            let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
            
            do {
                try self.context.execute(resetRequest)
                try self.context.execute(resetRequest2)
                try self.context.save()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    HapticsManger.shared.selectionVibrate(for: .heavy)
                    self.noBookmarksState ()
                }
                self.viewModel.renderViewData(tableView: tableView)
            } catch {
                //
            }
    }
}

