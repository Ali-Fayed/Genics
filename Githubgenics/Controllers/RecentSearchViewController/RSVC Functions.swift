//
//  File.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit
import CoreData

extension RecentSearchViewController : UISearchBarDelegate {
    
    //MARK:- Fetch Methods
    
    func renderViewData () {
        
        DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
            self?.lastSearch = result
            self?.tableView.reloadData()
            
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                self?.searchHistory = result
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Handle DB Excution
    
    // remove all database records
    func excute () {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.tableView.isHidden = true
                self.searchLabel.isHidden = false
            }
            renderViewData ()
        } catch {
            //
        }
    }
    
    //MARK:- Handle History View Conditions
    
    func renderRecentHistoryHiddenConditions () {
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
            searchLabel.isHidden = false
        } else {
            tableView.isHidden = false
            searchLabel.isHidden = true
        }
    }
    
}
