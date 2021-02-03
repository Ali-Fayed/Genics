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
    
    @IBOutlet weak var searchBaar: UISearchBar!
    @IBOutlet weak var clearAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    }
    
    
//MARK:- DataBase Methods

    
    @IBAction func clearAll(_ sender: UIButton) {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: K.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: K.lastSearchEntity)
        let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)

        do {
            try context.execute(resetRequest)
            try context.execute(resetRequest2)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
            Fetch().self.searchHistory { (result) in
            self.searchHistory = result
            }
            Fetch().self.lastSearch { (result) in
                self.lastSearch = result
            }
        } catch {
            print ("There was an error")
        }
    }
}



