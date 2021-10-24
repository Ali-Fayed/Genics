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
    private var usersListSubject = PublishSubject<[User]>()
    private var searchHistorySubject = PublishSubject<[SearchHistory]>()
    private var lastSearchSubject = PublishSubject<[LastSearch]>()
    var usersModelObservable: Observable<[User]> {
        return usersListSubject
    }
    var searchHistoryModelObservable: Observable<[SearchHistory]> {
        return searchHistorySubject
    }
    var lastSearchModelObservable: Observable<[LastSearch]> {
        return lastSearchSubject
    }
    var useCase: UserUseCase?
    var router: StrongRouter<UsersRoute>?
    
    var usersModel = [User]()
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    var pageNo: Int = 1
    var query : String = ""
    var totalPages: Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func getUsersCellsViewModel(at indexPath: IndexPath ) -> User {
        return usersModel[indexPath.row]
    }
    func fetchUsers(query: String) {
        useCase?.fetchUsersList(page: pageNo ,query: query, completion: { [weak self] result in
            switch result {
            case .success(let result):
                self?.usersModel = result
                self?.usersListSubject.onNext(result)
                self?.usersListSubject.onCompleted()
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
            }
        })
    }
    private func query(searchText: String?) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "a" : searchText
            }
            return queryString
        }()
        return query
    }
    func fetchMoreCells (tableView: UITableView, searchController: UISearchController) {
        pageNo += 1
        let searchText = searchController.searchBar.text
        let queryText = query(searchText: searchText)
        useCase?.fetchUsersList(page: pageNo ,query: queryText, completion: { [weak self] result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    if result.isEmpty == false {
                        self?.usersModel.append(contentsOf: result)
                        self?.usersListSubject.onNext(result)
                        self?.usersListSubject.onCompleted()
                        tableView.tableFooterView = nil
                    }
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
            }
        })
    }
    private func fetchSearchHistory() {
        useCase?.fetchSearchHistory(completion: { [weak self] result in
            self?.searchHistory = result
            self?.searchHistorySubject.onNext(result)
            self?.searchHistorySubject.onCompleted()
        })
    }
    private func fetchLastSearch() {
        useCase?.fetchLastSearch(completion: { [weak self] result in
            self?.lastSearch = result
            self?.lastSearchSubject.onNext(result)
            self?.lastSearchSubject.onCompleted()
        })
    }
    public func fetchDataBaseData() {
        fetchSearchHistory()
        fetchLastSearch()
    }
    func saveToLastSearch(model: User) {
        useCase?.saveToLastSearch(context: context, model: model)
    }
    func saveSearchWord(text: String) {
        useCase?.saveSearchHistory(context: context, text: text)
    }
    func saveUserToBookmarks(indexPath: IndexPath) {
        useCase?.saveUserToBookmarks(context: context, model: usersModel[indexPath.row])
    }
    func excute (tableView: UITableView , collectionView: UICollectionView, label: UILabel) {
        useCase?.excuteDataBase(context: context, completion: { [weak self] in
            tableView.isHidden = true
            label.isHidden = false
            self?.fetchDataBaseData()
        })
    }
    func deleteAndFetchRecentTableData(indexPath:IndexPath) {
        let item = searchHistory[indexPath.row]
        DataBaseManger.shared.delete(returnType: SearchHistory.self, delete: item)
        fetchSearchHistory()
    }
}
