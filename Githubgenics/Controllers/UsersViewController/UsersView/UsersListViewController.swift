//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit

class UsersListViewController: UIViewController  {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let longPress = UILongPressGestureRecognizer()
    var users : [items] = []
    var moreUsers : [items] = []
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var isPaginating = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var emptyHistoryView: UIView!
    @IBOutlet weak var signOutButton: UIBarButtonItem?
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBAction func refreshTable(_ sender: UIRefreshControl?) {
        sender?.endRefreshing()
        refreshList ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersList()
        tableView.addGestureRecognizer(longPress)
        signOutButton?.title = "Signout".localized()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
       
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.title = "Users".localized()
        self.tableView.isHidden = false
    }
    
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        performSignOut ()
    }
}
