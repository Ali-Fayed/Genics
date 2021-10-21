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
import RxSwift
import RxCocoa

class UsersViewModel {
    var usersListItems = PublishSubject<[User]>()
    var searchHistoryitems = PublishSubject<[SearchHistory]>()
    var lastSearchitems = PublishSubject<[LastSearch]>()
    var router: StrongRouter<UsersRoute>?
    var useCase: UserUseCase?
    
    var usersModel = [User]()
    var passedUsers: User?
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    
    var pageNo: Int = 1
    var totalPages: Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func getSearchHistoryViewModel(at indexPath: IndexPath ) -> SearchHistory {
        return searchHistory[indexPath.row]
    }
    func getUsersCellsViewModel(at indexPath: IndexPath ) -> User {
        return usersModel[indexPath.row]
    }
    func getLastSearchViewModel(at indexPath: IndexPath ) -> LastSearch {
        return lastSearch[indexPath.row]
    }
    func query(searchText : String?) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "a" : searchText
            }
            return queryString
        }()
        return query
    }
    func fetchUsers(query : String) {
        useCase?.fetchUsersList(page: pageNo ,query: query, completion: { [weak self] result in
            switch result {
            case .success(let result):
                self?.usersListItems.onNext(result)
                self?.usersListItems.onCompleted()
            case .failure(let error):
//                self?.usersListItems.onError(error)
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
            }
        })
    }
    func fetchMoreUsers(indexPath: IndexPath, searchController: UISearchController) {
//        if indexPath.row == usersModel.count - 1 {
//            if pageNo < totalPages {
//                pageNo += 1
                let searchText = searchController.searchBar.text
                let queryText = query(searchText: searchText)
                useCase?.fetchUsersList(page: 2 ,query: "q", completion: { [weak self] result in
                    switch result {
                    case .success(let result):
//                        if result.isEmpty == false {
//                            self?.usersListItems.onNext(result)
//                            self?.usersListItems.onCompleted()
//                        }
                        print(result)
                    case .failure(let error):
//                        self?.usersListItems.onError(error)
                        CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                    }
                })
//            }
    }
    func fetchRecentSearch () {
        DataBaseManger.shared.fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistoryitems.onNext(result)
            print(result)
            self?.searchHistoryitems.onCompleted()
        }
    }
    func fetchlastSearch() {
        DataBaseManger.shared.fetch(returnType: LastSearch.self) { [weak self] (result) in
            self?.lastSearchitems.onNext(result)
            print(result)
            self?.lastSearchitems.onCompleted()
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
            fetchRecentSearch ()
            fetchlastSearch()
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
