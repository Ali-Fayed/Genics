//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit

class UsersListViewController: UITableViewController {
    
    var users : [Users] = []
    var moreUsers : [Users] = []
    var isPaginating = false
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBAction func refreshTable(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        refreshList ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersList()
        signOutButton.title = "Signout".localized()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        tableView.resignFirstResponder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.title = "Github Users".localized()
        
    }
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        performSignOut ()
    }
}
