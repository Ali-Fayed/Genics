//
//  File.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//
import UIKit
import CoreData

extension RecentSearchViewController : UISearchBarDelegate {
    
    func renderDB () {
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
    
     func excute () {
        print("here")
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        
        do {
            try context.execute(resetRequest)
            try context.execute(resetRequest2)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
                HapticsManger.shared.selectionVibrate(for: .heavy)

            }
            Fetch().self.searchHistory { (result) in
                self.searchHistory = result
            }
            Fetch().self.lastSearch { (result) in
                self.lastSearch = result
            }
        } catch {
//            print ("There was an error")
        }
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        HapticsManger.shared.selectionVibrate(for: .medium)
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: Titles.deleteAllRecords, style: .default, handler: { (handler) in
                self.excute ()
            }))
            sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
            present(sheet, animated: true)
    }
    
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
