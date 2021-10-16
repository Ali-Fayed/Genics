//
//  UVC TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher

extension UsersViewController : UITableViewDataSource , UITableViewDelegate, UITableViewDataSourcePrefetching {
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
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        switch tableView {
        case self.tableView:
            for index in indexPaths {
                let query : String = {
                    var queryString = String()
                    if let searchText = searchController.searchBar.text {
                        queryString = searchText.isEmpty ? "a" : searchText
                    }
                    return queryString
                }()
                if index.row >= viewModel.numberOfUsersCells - 1 {
                    viewModel.fetchUsers(tableView: self.tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: query)
                }
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
                    self?.openInSafari(indexPath: indexPath)
                }
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self?.shareUser(indexPath: indexPath)
                }
                let saveImage = UIAction(
                    title: Titles.saveImage,
                    image: UIImage(systemName: "photo")) { _ in
                    self?.saveeImage(indexPath: indexPath)
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
    //MARK:- LongPress Actions
    func openInSafari (indexPath: IndexPath) {
        let usersURL = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        let safariVC = SFSafariViewController(url: URL(string: usersURL)!)
        self.present(safariVC, animated: true)
    }
    func shareUser (indexPath: IndexPath) {
        let avatarUrl = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let usersURL = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        let fileUrl = URL(string: avatarUrl)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        let sheetVC = UIActivityViewController(activityItems: [image!,usersURL], applicationActivities: nil)
        HapticsManger.shared.selectionVibrate(for: .medium)
        self.present(sheetVC, animated: true)
    }
    func saveeImage (indexPath: IndexPath) {
        let usersAvatarURL = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let fileUrl = URL(string: usersAvatarURL)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
}
