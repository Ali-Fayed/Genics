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
    var searchController = UISearchController(searchResultsController: nil)

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
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        conditionLabel.text = Titles.noBookmarks

        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        setupSearchController(search: searchController)
        
        view.addSubview(searchLabel)
        view.addSubview(conditionLabel)
        
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        
        renderViewData ()
        noBookmarksState ()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        renderViewData ()
        noBookmarksState ()
    }

 
    // layout and frame
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
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
                self.renderViewData()
            } catch {
                //
            }
    }
}

extension BookmarksViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchLabel.isHidden = true
        searchFromDB ()
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        renderViewData ()
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.searchLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
}
