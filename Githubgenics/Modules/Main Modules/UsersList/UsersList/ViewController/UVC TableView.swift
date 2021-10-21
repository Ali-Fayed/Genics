//
//  UVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher

extension UsersViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return viewModel.numberOfUsersCells
        case recentSearchTable:
            return viewModel.numberOfSearchHistoryCell
        default:
            break
        }
        return Int()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableView:
            let cell = tableView.dequeue() as UsersTableViewCell
            cell.cellData(with: viewModel.getUsersCellsViewModel(at: indexPath))
            return cell
        case recentSearchTable:
            let cell = tableView.dequeue() as SearchHistoryCell
            cell.cellData(with: viewModel.getSearchHistoryViewModel(at: indexPath))
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            showTableViewSpinner(tableView: tableView)
            viewModel.fetchMoreCells(tableView: tableView, loadingSpinner: loadingSpinner, indexPath: indexPath, searchController: searchController)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case self.tableView:
            viewModel.pushWithData(navigationController: navigationController!)
            if searchController.searchBar.text?.isEmpty == false {
                viewModel.saveToLastSearch(indexPath: indexPath)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch tableView {
        case self.tableView:
            viewModel.passedUsers = viewModel.getUsersCellsViewModel(at: indexPath)
            return indexPath
        default:
            break
        }
        return IndexPath()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case self.tableView:
            break
        case recentSearchTable:
            let headerText = UILabel()
            switch section {
            case 0:
                if viewModel.searchHistory.isEmpty == false {
                    headerText.text = Titles.recentSearch
                } else {
                    return nil
                }
            default:
                break
            }
            return headerText.text
        default:
            break
        }
        return String()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch tableView {
        case recentSearchTable:
            return .delete
        default:
            return .none
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case recentSearchTable:
            if editingStyle == .delete {
                tableView.beginUpdates()
                viewModel.deleteAndFetchRecentTableData(indexPath: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        default:
            break
        }
    }
}
