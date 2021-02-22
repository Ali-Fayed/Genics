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
    
    func renderDB () {
        DataBaseManger().Fetch(returnType: SearchHistory.self) { (result) in
            self.searchHistory = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        DataBaseManger().Fetch(returnType: LastSearch.self) { (result) in
            self.lastSearch = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Handle DB Excution
    
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
                HapticsManger.shared.selectionVibrate(for: .heavy)
                
            }
            DataBaseManger().Fetch(returnType: SearchHistory.self) { (result) in
                self.searchHistory = result
            }
            DataBaseManger().Fetch(returnType: LastSearch.self) { (result) in
                self.lastSearch = result
            }
        } catch {
            //
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        HapticsManger.shared.selectionVibrate(for: .medium)
        let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: Titles.deleteAllRecords, style: .default, handler: { [weak self](handler) in
            self?.excute ()
        }))
        sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
        present(sheet, animated: true)
    }
    
    //MARK:- Handle History View Conditions
    
    func renderHistoryViewCondition () {
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    //MARK:- Hanlde Table View Header
    
    func renderHeader () -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "labels")
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        sectionLabel.font = UIFont(name: "Helvetica", size: 12)
        sectionLabel.textColor = UIColor(named: "labels")
        sectionLabel.text = Titles.searchHistory
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
}
