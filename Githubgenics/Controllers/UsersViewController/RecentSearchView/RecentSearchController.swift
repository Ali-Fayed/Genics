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
    
    
    @IBOutlet weak var clearAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var ok: UILabel!
    
    
    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        Fetch().searchHistory { (result) in
            self.searchHistory = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        Fetch().lastSearch { (result) in
            self.lastSearch = result
            self.collectionView.reloadData()
        }
        self.tableView.tableHeaderView = self.collectionView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Fetch().searchHistory { (result) in
            self.searchHistory = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        Fetch().lastSearch { (result) in
            self.lastSearch = result
            self.collectionView.reloadData()
        }
        self.tableView.tableHeaderView = self.collectionView
    }
    


}



