//
//  BookmarksViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedRepositories = [SavedRepositories]()
    var bookmarkedUsers = [UsersDataBase]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersCell.nib(), forCellReuseIdentifier: K.usersCell)
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: K.repositoriesCell)
        searchBar.delegate = self
        renderDB ()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Bookmarks".localized()
        renderDB ()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}
