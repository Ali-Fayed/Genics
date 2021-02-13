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
    let longPress = UILongPressGestureRecognizer()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cells.usersNib(), forCellReuseIdentifier: Cells.usersCell)
        tableView.register(Cells.reposNib(), forCellReuseIdentifier: Cells.repositoriesCell)
        tableView.addGestureRecognizer(longPress)
        searchBar.delegate = self
        searchBar.placeholder = Titles.searchPlacholder
        tableView.tableFooterView = UIView()
        renderDB ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.BookmarksViewTitle
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        renderDB ()
    }
}
