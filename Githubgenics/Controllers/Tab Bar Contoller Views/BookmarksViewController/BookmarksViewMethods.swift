//
//  BookmarksViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import CoreData
import UIKit

extension BookmarksViewController {
    
    func renderDB () {
        Fetch().users { (result) in
            self.bookmarkedUsers = result
            self.tableView.reloadData()
        }
        Fetch().repository { (result) in
            self.savedRepositories = result
            self.tableView.reloadData()
        }
    }
    //MARK:- Search Method
    
    func searchFromDB () {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            Fetch().users { (result) in
                self.bookmarkedUsers = result
            }
            Fetch().repository { (result) in
                self.savedRepositories = result
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest()
            request.predicate = NSPredicate(format: "userName CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
            let request2 : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request2.predicate = NSPredicate(format: "repoName CONTAINS [cd] %@", searchText)
            request2.sortDescriptors = [NSSortDescriptor(key: "repoName", ascending: true)]
            do {
                bookmarkedUsers = try context.fetch(request)
                savedRepositories = try context.fetch(request2)
                
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
    //MARK:- Handle Long Press
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        HapticsManger.shared.selectionVibrate(for: .medium)
        let touchPoint = longPress.location(in: tableView)
        if tableView.indexPathForRow(at: touchPoint) != nil {
            let sheet = UIAlertController(title: Titles.more, message: nil , preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: Titles.removeAll, style: .default, handler: { [self] (url) in
                let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.usersEntity)
                let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.repositoryEntity)
                let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
                let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
                
                do {
                    try self.context.execute(resetRequest)
                    try self.context.execute(resetRequest2)
                    try self.context.save()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        HapticsManger.shared.selectionVibrate(for: .heavy)
                    }
                    Fetch().self.repository { (result) in
                        self.savedRepositories = result
                        self.tableView.reloadData()
                    }
                    Fetch().self.users { (result) in
                        self.bookmarkedUsers = result
                        self.tableView.reloadData()
                    }
                } catch {
//                    print ("There was an error")
                }
            }))
            sheet.addAction(UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil ))
            present(sheet, animated: true)
        }
    }
}
