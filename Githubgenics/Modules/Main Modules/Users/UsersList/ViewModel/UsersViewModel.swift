//
//  UsersViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import CoreData
import JGProgressHUD

class UsersViewModel {
    
    var searchHistory = [SearchHistory]()
    var usersModel = [User]()
    var passedUsers : User?
    var lastSearch = [LastSearch]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pageNo : Int = 1
    var totalPages : Int = 100
    var isFetching = false

    var numberOfSearchHistoryCell: Int {
        return searchHistory.count
    }
    var numberOfUsersCells: Int {
        return usersModel.count
    }
    
    var numberOfLastSearchCells: Int {
        return lastSearch.count
    }
    
    func getSearchHistoryViewModel( at indexPath: IndexPath ) -> SearchHistory {
        return searchHistory[indexPath.row]
    }
    
    func getUsersCellsViewModel( at indexPath: IndexPath ) -> User {
        return usersModel[indexPath.row]
    }
        
    func getLastSearchViewModel( at indexPath: IndexPath ) -> LastSearch {
        return lastSearch[indexPath.row]
    }
        
    // fetch users in table
    func fetchUsers (tableView: UITableView, searchController: UISearchController, loadingIndicator: JGProgressHUD, query : String) {
        isFetching = true
        let data = GitRequestRouter.gitSearchUsers(pageNo, query)
        NetworkingManger.shared.performRequest(dataModel: Users.self, requestData: data) { [weak self] (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    if searchController.searchBar.text?.isEmpty == true {
                        self?.usersModel.append(contentsOf: result.items)
                        self?.pageNo += 1
                        self?.isFetching = false
                        loadingIndicator.dismiss()
                    } else {
                        self?.usersModel = result.items
                        tableView.isHidden = false
                    }
                    tableView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
        
    func recentSearchData (collectionView: UICollectionView, tableView: UITableView) {
            DataBaseManger().fetch(returnType: LastSearch.self) { [weak self] (result) in
                 self?.lastSearch = result
                 collectionView.reloadData()
            DataBaseManger().fetch(returnType: SearchHistory.self) { [weak self] (result) in
                 self?.searchHistory = result
                 tableView.reloadData()
            }
        }
    }
    
    func excute (tableView: UITableView , collectionView: UICollectionView, label: UILabel) {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                tableView.reloadData()
                collectionView.reloadData()
                tableView.isHidden = true
                label.isHidden = false
            }
            DataBaseManger().fetch(returnType: LastSearch.self) { [weak self] (result) in
                self?.lastSearch = result
                collectionView.reloadData()
            }
                DataBaseManger().fetch(returnType: SearchHistory.self) { [weak self] (result) in
                    self?.searchHistory = result
                    tableView.reloadData()
                }
            } catch {
            //
        }
    }
    
    func saveUserToBookmarks (indexPath: IndexPath) {
        let model = usersModel[indexPath.row]
        let items = UsersDataBase(context: self.context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        try! self.context.save()
    }
    
    func saveToLastSearch (indexPath: IndexPath) {
        let model = usersModel[indexPath.row]
        let items = LastSearch(context: self.context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        try! self.context.save()
    }
    
    func pushWithData (navigationController: UINavigationController) {
        let publicProfileView = PublicUserProfileViewController.instaintiate(on: .publicProfileView)
        publicProfileView.viewModel.passedUser = passedUsers
        publicProfileView.navigationItem.largeTitleDisplayMode = .never
        publicProfileView.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController.pushViewController(publicProfileView, animated: true)
    }
    
    func deleteAndFetchRecentTableData (indexPath:IndexPath) {
        let item = searchHistory[indexPath.row]
        DataBaseManger.shared.delete(returnType: SearchHistory.self, delete: item)
        DataBaseManger.shared.fetch(returnType: SearchHistory.self) { (history) in
            self.searchHistory = history
        }
    }
    
    func saveSearchWord (text: String) {
        let history = SearchHistory(context: self.context)
        history.keyword = text
        try! self.context.save()
    }
    
}
