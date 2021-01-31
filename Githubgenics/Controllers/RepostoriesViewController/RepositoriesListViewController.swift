//
//  RepositoriesListViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import CoreData



class RepositoriesListViewController: UITableViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var fetchedRepositories: [Repository] = []
    var savedRepositories = [SavedRepositories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: K.repositoriesCell)
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        tableView.rowHeight = 120
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Repositories".localized()
    }
    
    
}

