//
//  UVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher
import RxCocoa
import RxSwift

extension UsersViewController: UITableViewDelegate {
    func bindUsersListTableView() {
         /// usersListTableView rowHeight
         usersListTableView.rx.rowHeight.onNext(60)
         /// usersListTableView dataSource
        viewModel.usersListdataSource.bind(to: usersListTableView.rx.items(cellIdentifier: "UsersTableViewCell", cellType: UsersTableViewCell.self)) { [weak self] row, users, cell in
            cell.cellData(with: users)
            self?.usersListTableView.isHidden = false
            self?.loadingSpinner.dismiss()
        }.disposed(by: bag)
         /// didSelectRow
        Observable
            .zip(usersListTableView.rx.itemSelected, usersListTableView.rx.modelSelected(User.self))
            .bind { [weak self] indexPath, users in
                self?.usersListTableView.deselectRow(at: indexPath, animated: true)
                self?.viewModel.router?.trigger(.publicUserProfile(user: users))
                if self?.searchController.searchBar.text?.isEmpty == false {
                    self?.viewModel.saveToLastSearch(model: users)
                }
        }.disposed(by: bag)
        /// willDisplayCell
        usersListTableView.rx.prefetchRows.subscribe(onNext: { [self] indexPaths in
                 for index in indexPaths {
                     if index.row == viewModel.usersModel.count - 1 {
                         self.viewModel.pageNo+=1
                         self.viewModel.isPaginating = true
                         print(self.viewModel.pageNo+=1)
                         self.showTableViewSpinner(tableView: usersListTableView)
                         self.viewModel.fetchUsers(pageNo: self.viewModel.pageNo, query: "J")
                     }
                 }
             }).disposed(by: bag)
     }
    /// long press menu
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch tableView {
        case self.usersListTableView:
            let identifier = "\(String(describing: index))" as NSString
            return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { [weak self]_ in
                let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                    self?.viewModel.saveUserToBookmarks(indexPath: indexPath)
                }
                let safariAction = UIAction(
                    title: Titles.openInSafari,
                    image: UIImage(systemName: "link")) { _ in
                        let usersURLstring = self?.viewModel.getUsersCellsViewModel(at: indexPath).userURL
                        self?.viewModel.router?.trigger(.openInSafari(indexPath: usersURLstring!))
                    }
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    let avatarUrl = self?.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
                    let usersURL = self?.viewModel.getUsersCellsViewModel(at: indexPath).userURL
                    self?.viewModel.router?.trigger(.shareUser(avatarURL: avatarUrl!, userURL: usersURL!))
                    }
                let saveImage = UIAction(
                    title: Titles.saveImage,
                    image: UIImage(systemName: "photo")) { _ in
                        let usersAvatarURL = self?.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
                        self?.viewModel.router?.trigger(.saveImage(avatarURL: usersAvatarURL!))
                    }
                return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, saveImage, shareAction])
            }
        default:
            break
        }
        return UIContextMenuConfiguration()
    }
    //MARK: - searchHistory tableView
    func bindSearchHistoryTableView () {
        /// recentSearchTable rowHeight
        recentSearchTableView.rx.rowHeight.onNext(50)
        /// searchHistory dataSource
        viewModel.searchHistoryDataSource.bind(to: recentSearchTableView.rx.items(cellIdentifier: String(describing: SearchHistoryCell.self), cellType: SearchHistoryCell.self)) { row, model, cell  in
            cell.cellData(with: model)
        }.disposed(by: bag)
        /// searchHistory delete
        Observable
            .zip(recentSearchTableView.rx.itemDeleted, recentSearchTableView.rx.modelDeleted(SearchHistory.self))
            .bind { [weak self] indexPath, searchHistory in
                self?.recentSearchTableView.beginUpdates()
                self?.recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
                self?.viewModel.deleteAndFetchRecentTableData(searchHistory: searchHistory)
                self?.recentSearchTableView.endUpdates()
        }.disposed(by: bag)
        /// didSelectRow
        Observable
            .zip(recentSearchTableView.rx.itemSelected, recentSearchTableView.rx.modelSelected(SearchHistory.self))
            .bind { [weak self] indexPath, searchHistory in
                DispatchQueue.main.async {
                    self?.recentSearchTableView.deselectRow(at: indexPath, animated: true)
                    self?.searchController.searchBar.text = searchHistory.keyword
                    self?.searchController.searchBar.becomeFirstResponder()
                }
        }.disposed(by: bag)
    }
}
//MARK: - CollectionView
extension UsersViewController {
    func bindLastSearchCollectionView () {
        /// lastSearchitems dataSource
        viewModel.lastSearchDataSource
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: LastSearchCollectionCell.self), cellType: LastSearchCollectionCell.self)) { row, lastSearch, cell  in
                cell.cellData(with: lastSearch)
            }.disposed(by: bag)
        /// didSelectRow
        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(LastSearch.self))
            .bind { [weak self] indexPath, lastSearch in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
                let safariVC = SFSafariViewController(url: URL(string: lastSearch.userURL!)!)
                self?.present(safariVC, animated: true)
            }.disposed(by: bag)
    }
}
