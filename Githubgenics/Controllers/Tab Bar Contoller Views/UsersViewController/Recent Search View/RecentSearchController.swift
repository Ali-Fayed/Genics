//
//  SearchHistoryContainer.swift
//  Githubgenics
//
//  Created by Ali Fayed on 23/01/2021.
//

import UIKit
import SafariServices
import CoreData

class RecentSearchViewController:  UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let longPress = UILongPressGestureRecognizer()
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tableView.tableHeaderView = self.collectionView
        tableView.addGestureRecognizer(longPress)
        self.tableView.sectionHeaderHeight = 120
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        tableView.tableFooterView = UIView()
        renderDB ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.tableHeaderView = self.collectionView
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        renderDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}
