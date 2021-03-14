//
//  BVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices
import CoreData

extension BookmarksViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
            
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bookmarkedUsers.count
        default:
            return savedRepositories.count
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeue() as UsersCell
            cell.CellData(with: bookmarkedUsers[indexPath.row])
            if bookmarkedUsers.isEmpty == true {

            }
            return cell
        default:
            let cell = tableView.dequeue() as ReposCell
            cell.CellData(with: savedRepositories[indexPath.row])
            return cell
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            guard let url = bookmarkedUsers[indexPath.row].userURL else { return }
            let vc = SFSafariViewController(url: URL(string: url)!)
            present(vc, animated: true)
        default:
            let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
            vc?.savedRepos = passedRepo
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case 0:
            break
        default:
            passedRepo = savedRepositories[indexPath.row]
        }
        return indexPath
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
            if bookmarkedUsers.isEmpty == false {
                headerText.text = Titles.usersViewTitle
            } else {
                headerText.text = nil
            }
        default:
            if savedRepositories.isEmpty == false {
                headerText.text = Titles.repositoriesViewTitle
            } else {
                headerText.text = nil
            }
        }
        return headerText.text
    }
        
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                let item = bookmarkedUsers[indexPath.row]
                DataBaseManger().Delete(returnType: UsersDataBase.self, Delete: item)
                DataBaseManger().Fetch(returnType: UsersDataBase.self) { (users) in
                    self.bookmarkedUsers = users
                }
                noBookmarksState ()
            default:
                let item = savedRepositories[indexPath.row]
                DataBaseManger().Delete(returnType: SavedRepositories.self, Delete: item)
                DataBaseManger().Fetch(returnType: SavedRepositories.self) { (repos) in
                    self.savedRepositories = repos
                }
                noBookmarksState ()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
        
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            
            let remove = UIAction(title: Titles.removeAll, image: UIImage(systemName: "delete.right")) { _ in
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
                        self.noBookmarksState ()
                    }
                    self.renderViewData()
                } catch {
                    //
                }
            }
            
            return UIMenu(title: "", image: nil, children: [remove])
        }
    }
    
    // excute
    func searchFromDB () {
        guard let searchText = searchRepositoriesBar.text else { return }
        if searchText.isEmpty {
            renderViewData()
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
}
