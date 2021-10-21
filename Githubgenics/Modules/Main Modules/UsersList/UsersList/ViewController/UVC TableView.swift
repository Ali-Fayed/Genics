//
//  UVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher

extension UsersViewController: UITableViewDelegate {
    func bindUsersListTableView() {
         /// usersListTableView rowHeight
         tableView.rx.rowHeight.onNext(60)
         /// usersListTableView dataSource
         viewModel.usersListItems.bind(to: tableView.rx.items(cellIdentifier: "UsersTableViewCell", cellType: UsersTableViewCell.self)) {[weak self] row, model, cell  in
             cell.cellData(with: model)
             self?.tableView.isHidden = false
             self?.loadingSpinner.dismiss()
         }.disposed(by: bag)
         /// didSelectRow
         tableView.rx.modelSelected(User.self).bind { [weak self] result in
             self?.viewModel.router?.trigger(.publicUserProfile(user: result))
             if self?.searchController.searchBar.text?.isEmpty == false {
                 self?.viewModel.saveToLastSearch(model: result)
             }
         }.disposed(by: bag)
         /// selectedItem
         tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
             self?.tableView.deselectRow(at: indexPath, animated: true)
         }).disposed(by: bag)
     }
    
    //MARK: - searchHistory tableView
    func bindSearchHistoryTableView () {
        /// recentSearchTable rowHeight
        recentSearchTable.rx.rowHeight.onNext(50)
        /// searchHistory dataSource
        viewModel.searchHistoryitems.bind(to: recentSearchTable.rx.items(cellIdentifier: "SearchHistoryCell", cellType: SearchHistoryCell.self)) { row, model, cell  in
            cell.cellData(with: model)
        }.disposed(by: bag)
        /// searchHistory delete
        recentSearchTable.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            self?.recentSearchTable.beginUpdates()
            self?.recentSearchTable.deleteRows(at: [indexPath], with: .fade)
            self?.recentSearchTable.endUpdates()
        }).disposed(by: bag)
        
        recentSearchTable.rx.modelDeleted(SearchHistory.self).bind { [weak self] result in
            self?.recentSearchTable.beginUpdates()
            DataBaseManger.shared.delete(returnType: SearchHistory.self, delete: result)
            self?.recentSearchTable.endUpdates()
        }.disposed(by: bag)

    }

    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch tableView {
        case self.tableView:
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

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//            return .delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                tableView.beginUpdates()
//                viewModel.deleteAndFetchRecentTableData(indexPath: indexPath)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.endUpdates()
//            }
//    }
}
