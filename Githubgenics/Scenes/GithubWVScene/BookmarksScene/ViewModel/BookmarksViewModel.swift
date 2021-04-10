//
//  BookmarksViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import CoreData
import JGProgressHUD

class BookmarksViewModel {
    
    // data models
    var savedRepositories = [SavedRepositories]()
    var bookmarkedUsers = [UsersDataBase]()
    var passedRepo : SavedRepositories?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var numberOfReposCells: Int {
        return savedRepositories.count
    }
    var numberOfUsersCells: Int {
        return bookmarkedUsers.count
    }

    func getReposViewModel( at indexPath: IndexPath ) -> SavedRepositories {
        return savedRepositories[indexPath.row]
    }
    
    func getUsersViewModel( at indexPath: IndexPath ) -> UsersDataBase {
        return bookmarkedUsers[indexPath.row]
    }
    
    // fetch
    func renderViewData (tableView: UITableView) {
        DataBaseManger.shared.Fetch(returnType: UsersDataBase.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            tableView.reloadData()
        }
        DataBaseManger.shared.Fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.savedRepositories = reps
            tableView.reloadData()
        }
    }
    
    // excute
    func searchFromDB (tableView: UITableView ,searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            renderViewData(tableView: tableView)
            DispatchQueue.main.async {
                tableView.reloadData()
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
    
    
    func noBookmarksState (tableView: UITableView, conditionLabel: UILabel ) {
    if bookmarkedUsers.isEmpty == true , savedRepositories.isEmpty == true {
        conditionLabel.isHidden = false
        tableView.isHidden = true
    } else {
        conditionLabel.isHidden = true
        tableView.isHidden = false
    }
}
    
    func deleteAndFetchUsers(at indexPath: IndexPath , tableView: UITableView, conditionLabel: UILabel) {
        let item = getUsersViewModel(at: indexPath)
        DataBaseManger().Delete(returnType: UsersDataBase.self, Delete: item)
        DataBaseManger().Fetch(returnType: UsersDataBase.self) { (users) in
            self.bookmarkedUsers = users
        }
        noBookmarksState (tableView: tableView, conditionLabel: conditionLabel)
    }
    
    func deleteAndFetchRepos(at indexPath: IndexPath , tableView: UITableView, conditionLabel: UILabel) {
        let item = savedRepositories[indexPath.row]
        DataBaseManger().Delete(returnType: SavedRepositories.self, Delete: item)
        DataBaseManger().Fetch(returnType: SavedRepositories.self) { (repos) in
            self.savedRepositories = repos
        }
        noBookmarksState (tableView: tableView, conditionLabel: conditionLabel)
    }
    
    func pushToDestnationVC(indexPath: IndexPath, navigationController: UINavigationController , view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.savedRepos = passedRepo
        vc?.viewModel.renderCachedReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
        navigationController.pushViewController(vc!, animated: true)
    }
    
}

extension BookmarksViewController {
    
    @IBAction func removeAll(_ sender: UIButton) {
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
                    self.viewModel.noBookmarksState (tableView: self.tableView, conditionLabel: self.conditionLabel)

                }
                self.viewModel.renderViewData(tableView: tableView)
            } catch {
                //
            }
    }
    
}
