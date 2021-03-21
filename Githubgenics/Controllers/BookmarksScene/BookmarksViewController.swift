//
//  BookmarksViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit
import CoreData

class BookmarksViewController: ViewSetups {
    
    // data models
    var savedRepositories = [SavedRepositories]()
    var bookmarkedUsers = [UsersDataBase]()
    var passedRepo : SavedRepositories?

    // before search label
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForSaved
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    var searchController = UISearchController(searchResultsController: nil)

     // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        // tableview
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = 60
        noContentLabel.text = Titles.noBookmarks
        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        setupSearchBar(search: searchController)
        view.addSubview(searchLabel)
        // hide label and zero opacity
        view.addSubview(searchLabel)
        view.addSubview(noContentLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        // fetch bookmarks
        renderViewData ()
        noBookmarksState ()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        renderViewData ()
        noBookmarksState ()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        noContentLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Fetch Methods
    
    // fetch
    func renderViewData () {
        DataBaseManger.shared.Fetch(returnType: UsersDataBase.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            self?.tableView.reloadData()
        }
        DataBaseManger.shared.Fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.savedRepositories = reps
            self?.tableView.reloadData()
        }
    }
    
    func noBookmarksState () {
        if bookmarkedUsers.isEmpty == true , savedRepositories.isEmpty == true {
            noContentLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noContentLabel.isHidden = true
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
                self.renderViewData()
            } catch {
                //
            }
    }
}

