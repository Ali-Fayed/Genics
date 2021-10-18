//
//  HomeViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 07/04/2021.
//

import UIKit
import SafariServices
import XCoordinator

class HomeViewModel {
    var profileTableData = [ProfileTableData]()
    var searchTableData = [ProfileTableData]()
    var searchHistory = [SearchHistory]()
    var router: StrongRouter<HomeRoute>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var numberOfHomeTableCells: Int {
        return profileTableData.count
    }
    var numberOfSearchOptionsCells: Int {
        return searchTableData.count
    }
    var numberOfSearchHistoryCells: Int {
        return searchHistory.count
    }
    func getHomeCellViewModel( at indexPath: IndexPath ) -> ProfileTableData {
        return profileTableData[indexPath.row]
    }
    func getSearchHistoryCellViewModel( at indexPath: IndexPath ) -> SearchHistory {
        return searchHistory[indexPath.row]
    }
    func getSearchOptionsCellViewModel( at indexPath: IndexPath ) -> ProfileTableData {
        return searchTableData[indexPath.row]
    }
    func initHomeTableCellData () {
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", image: "Profile"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", image: "Issues"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.gitHubURL)", image: "GithubWeb"))
    }
    func initSearchOptionsTableCellData () {
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", image: "peoples"))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", image: "repoSearch" ))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", image: "issue"))
    }
    func initLocalDataBaseCellData () {
        DataBaseManger().fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
        }
    }
    func pushToDestinationVC (indexPath: IndexPath) {
        if indexPath.row == 0 {
            router?.trigger(.users)
        } else if indexPath.row == 1 {
            router?.trigger(.repos)
        } else if indexPath.row == 2 {
            router?.trigger(.issues)
        } else if indexPath.row == 3 {
            router?.trigger(.githubWebSite)
        }
    }
    func pushToDestinationSearchedVC (indexPath: IndexPath, searchText: String) {
        if indexPath.row == 0 {
            router?.trigger(.searchUsers(serachText: searchText))
        } else if indexPath.row == 1 {
            router?.trigger(.searchRepos(serachText: searchText))
        } else if indexPath.row == 2 {
            router?.trigger(.searchIssues(serachText: searchText))
        }
    }
    func saveSearchWord (text: String) {
        let history = SearchHistory(context: self.context)
        history.keyword = text
        try! self.context.save()
    }
    func passCellTextToSearchBar (at indexPath: IndexPath, with tableView: UITableView, with searchController: UISearchController) {
        let history = getSearchHistoryCellViewModel(at: indexPath).keyword
        DispatchQueue.main.async {
            searchController.searchBar.text = history
            tableView.reloadData()
            searchController.searchBar.becomeFirstResponder()
        }
    }
    func initTableViewHeaderInSection (with labelText: String, view: UIView) -> UIView {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: sectionView.frame.size.width - 15, height: sectionView.frame.height-10))
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        sectionView.addSubview(label)
        label.text = Titles.featuresTitle
        label.text = labelText
        return sectionView
    }
    
    func pushToRepoURLPage (viewController: UIViewController) {
        router?.trigger(.appRepoWeb)
    }
    func handleDelete (at indexPath: IndexPath) {
        let item = getSearchHistoryCellViewModel(at: indexPath)
        DataBaseManger.shared.delete(returnType: SearchHistory.self, delete: item)
        DataBaseManger.shared.fetch(returnType: SearchHistory.self) { (history) in
            self.searchHistory = history
        }
    }
}
