//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/01/2021.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    var searchedUsers : [items] = []
    var passedKeys: SearchHistory?

    @IBOutlet weak var Searchbaar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchHistoryView: UIView!


    //MARK:- View LifeCycle Methods


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: K.userSerchCell)
        Searchbaar.showsCancelButton = true
        navigationItem.hidesBackButton = true
        Searchbaar.delegate = self
        Searchbaar.placeholder = "Search".localized()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        fetchAndDisplaySearchViewUsers()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.isHidden = true
        self.tabBarController?.navigationItem.title = "Search".localized()
        if tableView.isHidden == true {
            loadingIndicator.stopAnimating()
        }
        Searchbaar.text = passedKeys?.keyword
    }

    func fetchAndDisplaySearchViewUsers() {
            self.loadingIndicator.startAnimating()
        UsersRouter().fetchUserstoAvoidIndexError { repositories in
            self.searchedUsers = repositories
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()

        }
    }

}



