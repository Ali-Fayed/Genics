//
//  HomeViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 07/04/2021.
//

import UIKit
import SafariServices

class HomeViewModel {
    
    var profileTableData = [ProfileTableData]()
    var searchTableData = [ProfileTableData]()
    var searchHistory = [SearchHistory]()
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
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "Profile"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "Repositories" ))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", Image: "Issues"))
        profileTableData.append(ProfileTableData(cellHeader: "\(Titles.gitHubURL)", Image: "GithubWeb"))
    }
    
    func initSearchOptionsTableCellData () {
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.usersViewTitle)", Image: "peoples"))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.repositoriesViewTitle)", Image: "repoSearch" ))
        searchTableData.append(ProfileTableData(cellHeader: "\(Titles.issuesViewTitle)", Image: "issue"))
    }
    
    func initLocalDataBaseCellData () {
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
        }
    }
    
    func pushToDestinationVC (indexPath: IndexPath, navigationController: UINavigationController) {
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.usersView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
            navigationController.pushViewController(vc!, animated: true)
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.reposView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.repositoriesViewController) as? RepositoriesViewController
            navigationController.pushViewController(vc!, animated: true)
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.issuesView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.issuesViewController) as? IssuesViewController
            navigationController.pushViewController(vc!, animated: true)
        } else if indexPath.row == 3 {
            let vc = GithubViewController()
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.navigationController?.navigationBar.prefersLargeTitles = false
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushToDestinationSearchedVC (indexPath: IndexPath, navigationController: UINavigationController, searchText: String) {
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: Storyboards.usersView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
            vc?.searchController.searchBar.text = searchText
            vc?.query = searchText
            navigationController.pushViewController(vc!, animated: true)
        } else if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: Storyboards.reposView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.repositoriesViewController) as? RepositoriesViewController
            vc?.searchController.searchBar.text = searchText
            vc?.query = searchText
            navigationController.pushViewController(vc!, animated: true)
            
        } else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: Storyboards.issuesView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.issuesViewController) as? IssuesViewController
            vc?.searchController.searchBar.text = searchText
            navigationController.pushViewController(vc!, animated: true)
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
        let url = "https://github.com/Ali-Fayed/Githubgenics"
        let vc = SFSafariViewController(url: URL(string: url)!)
        viewController.present(vc, animated: true)
    }
    
    func handleDelete (at indexPath: IndexPath) {
        let item = getSearchHistoryCellViewModel(at: indexPath)
        DataBaseManger.shared.Delete(returnType: SearchHistory.self, Delete: item)
        DataBaseManger.shared.Fetch(returnType: SearchHistory.self) { (history) in
            self.searchHistory = history
        }
    }
}
