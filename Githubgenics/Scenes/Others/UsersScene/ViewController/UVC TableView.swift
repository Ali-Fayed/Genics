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
            cell.CellData(with: viewModel.getUsersCellsViewModel(at: indexPath))
            return cell
        case recentSearchTable:
            let cell = tableView.dequeue() as SearchHistoryCell
            cell.CellData(with: viewModel.getSearchHistoryViewModel(at: indexPath))
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
        case recentSearchTable:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            if indexPath.row == viewModel.numberOfUsersCells - 1 {
                showTableViewSpinner(tableView: tableView)
                if pageNo < totalPages {
                    pageNo += 1
                    let searchText = searchController.searchBar.text
                    let query = viewModel.query(searchText: searchText)
                    viewModel.fetchMoreUsers(tableView: tableView, tableViewFooter: tableFooterView, query: query, page: pageNo)
                }
            }
        case recentSearchTable:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch tableView {
        case self.tableView:
            viewModel.passedUsers = viewModel.getUsersCellsViewModel(at: indexPath)
            return indexPath
        case recentSearchTable:
            break
        default:
            break
        }
        return IndexPath()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            return 60
        case recentSearchTable:
            return 50
        default:
            break
        }
        return CGFloat()
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
        case recentSearchTable:
            break
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
        case self.tableView:
            return .none
        case recentSearchTable:
            return .delete
        default:
            break
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            break
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
        let url = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    func shareUser (indexPath: IndexPath) {
        let avatarUrl = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let url = self.viewModel.getUsersCellsViewModel(at: indexPath).userURL
        let fileUrl = URL(string: avatarUrl)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        let sheetVC = UIActivityViewController(activityItems: [image!,url], applicationActivities: nil)
        HapticsManger.shared.selectionVibrate(for: .medium)
        self.present(sheetVC, animated: true)
    }

    func saveeImage (indexPath: IndexPath) {
        let url = self.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
        let fileUrl = URL(string: url)
        let data = try? Data(contentsOf: fileUrl!)
        let image = UIImage(data: data!)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
}
