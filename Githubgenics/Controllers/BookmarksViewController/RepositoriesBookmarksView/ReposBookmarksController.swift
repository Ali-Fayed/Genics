//
//  ReposBookmarksController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/01/2021.
//

import UIKit
import SafariServices
import CoreData

class ReposBookmarksController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedRepositories = [SavedRepositories]()

    @IBOutlet weak var searchBar: UISearchBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: K.repositoriesCell)
        Fetch().repository { (result) in
            self.savedRepositories = result
        }
        searchBar.delegate = self
        tableView.rowHeight = 120
        navigationItem.title = "Repositories".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
}


