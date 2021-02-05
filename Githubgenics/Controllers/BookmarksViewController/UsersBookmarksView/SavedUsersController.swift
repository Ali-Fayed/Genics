//
//  SavedUsersController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit
import Kingfisher
import CoreData

class SavedUsersController: UITableViewController {
    
    var bookmarkedUsers = [UsersDataBase]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SignOutBT: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersCell.nib(), forCellReuseIdentifier: K.usersCell)
        searchBar.delegate = self
        SignOutBT.title = "Repos".localized()
        Fetch().users { (result) in
            self.bookmarkedUsers = result
            self.tableView.reloadData()
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Bookmarks".localized()
        Fetch().users { (result) in
            self.bookmarkedUsers = result
            self.tableView.reloadData()
        }
        self.tabBarController?.navigationItem.rightBarButtonItem = SignOutBT
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil

    }


}
