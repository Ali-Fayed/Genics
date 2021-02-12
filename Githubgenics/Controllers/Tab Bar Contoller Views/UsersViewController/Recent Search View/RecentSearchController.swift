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
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ok: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        renderDB ()
        self.tableView.tableHeaderView = self.collectionView
        self.tableView.sectionHeaderHeight = 120
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        renderDB()
        self.tableView.tableHeaderView = self.collectionView
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
}
