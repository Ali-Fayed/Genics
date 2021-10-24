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
    let usersListdataSource = BehaviorRelay(value: [User]())
    let searchHistoryDataSource = BehaviorRelay(value: [SearchHistory]())
    let lastSearchDataSource = BehaviorRelay(value: [LastSearch]())
    var usersModel = [User]()
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    var useCase: UserUseCase?
    var router: StrongRouter<UsersRoute>?
    var pageNo: Int = 1
    var isPaginating = false
    var query: String = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func getUsersCellsViewModel(at indexPath: IndexPath ) -> User {
        return usersModel[indexPath.row]
    }
    func query(searchText: String?) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "J" : searchText
            }
            return queryString
        }()
        return query
    }
    func fetchUsers(pageNo: Int, query: String) {
        useCase?.fetchUsersList(page: pageNo ,query: query, completion: { [weak self] result in
            switch result {
            case .success(let result):
                if self!.isPaginating == true {
                    self?.usersModel.append(contentsOf: result)
                    guard let usersModel = self?.usersModel else {return}
                    self?.usersListdataSource.accept(usersModel)
                } else {
                    self?.usersModel = result
                    guard let usersModel = self?.usersModel else {return}
                    self?.usersListdataSource.accept(usersModel)
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
            }
        })
    }
    private func fetchSearchHistory() {
        useCase?.fetchSearchHistory(completion: { [weak self] result in
            self?.searchHistory = result
            guard let searchHistory = self?.searchHistory else {return}
            self?.searchHistoryDataSource.accept(searchHistory)
        })
    }
    private func fetchLastSearch() {
        useCase?.fetchLastSearch(completion: { [weak self] result in
            self?.lastSearch = result
            guard let lastSearch = self?.lastSearch else {return}
            self?.lastSearchDataSource.accept(lastSearch)
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
    func deleteAndFetchRecentTableData(searchHistory: SearchHistory) {
        DataBaseManger.shared.delete(returnType: SearchHistory.self, delete: searchHistory)
        fetchSearchHistory()
    }
}
