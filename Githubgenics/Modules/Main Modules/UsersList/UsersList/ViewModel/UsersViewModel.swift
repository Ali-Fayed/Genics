//
//  UsersViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import CoreData
import JGProgressHUD
import XCoordinator

class UsersViewModel {
    var usersModel = [User]()
    var passedUsers: User?
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    var pageNo: Int = 1
    var totalPages: Int = 100
    var useCase: UserUseCase?
    var router: StrongRouter<UsersRoute>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var numberOfSearchHistoryCell: Int {
        return searchHistory.count
    }
    var numberOfUsersCells: Int {
        return usersModel.count
    }
    var numberOfLastSearchCells: Int {
        return lastSearch.count
    }
    func getSearchHistoryViewModel(at indexPath: IndexPath ) -> SearchHistory {
        return searchHistory[indexPath.row]
    }
    func getUsersCellsViewModel(at indexPath: IndexPath ) -> User {
        return usersModel[indexPath.row]
    }
    func getLastSearchViewModel(at indexPath: IndexPath ) -> LastSearch {
        return lastSearch[indexPath.row]
    }
    func fetchUsers(tableView: UITableView, loadingIndicator: JGProgressHUD, query : String) {
        useCase?.fetchUsersList(page: pageNo ,query: query, completion: { [weak self] result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.usersModel = result
                    tableView.isHidden = false
                    tableView.reloadData()
                    loadingIndicator.dismiss()
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingIndicator.dismiss()
            }
        })
    }
    func query (searchText : String? ) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "a" : searchText
            }
            return queryString
        }()
        return query
    }
    func fetchMoreCells (tableView: UITableView, loadingSpinner: JGProgressHUD, indexPath: IndexPath, searchController: UISearchController) {
        if indexPath.row == numberOfUsersCells - 1 {
            if pageNo < totalPages {
                pageNo += 1
                let searchText = searchController.searchBar.text
               let queryText = query(searchText: searchText)
                useCase?.fetchUsersList(page: pageNo ,query: queryText, completion: { [weak self] result in
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            if result.isEmpty == false {
                                self?.usersModel.append(contentsOf: result)
                                tableView.reloadData()
                                tableView.tableFooterView = nil
                            } else {
                                tableView.tableFooterView = nil
                            }
                        }
                    case .failure(let error):
                        CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                        loadingSpinner.dismiss()
                    }
                })
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
        guard let passedUsers = passedUsers else {return}
        router?.trigger(.publicUserProfile(user: passedUsers))
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
