//
//  UVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit
import Kingfisher


extension UsersViewController : UITableViewDataSource , UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return usersModel.count
        } else if tableView == self.recentSearchTable {
            return searchHistory.count
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeue() as UsersCell
            cell.CellData(with: usersModel[indexPath.row])
            return cell
        } else if tableView == self.recentSearchTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
            cell.textLabel?.text = searchHistory[indexPath.row].keyword
            cell.accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.backward"))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == self.tableView {
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = UIStoryboard.init(name: Storyboards.detail , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.detailViewControllerID) as? PublicUserProfileViewController
            vc?.passedUser = passedUsers
            self.navigationController?.pushViewController(vc!, animated: true)
            let model = usersModel[indexPath.row]
            let items = LastSearch(context: self.context)
            items.userName = model.userName
            items.userAvatar = model.userAvatar
            items.userURL = model.userURL
            try! self.context.save()
        }
        else if tableView == self.recentSearchTable {
            tableView.deselectRow(at: indexPath, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            // fetch more
            
            if indexPath.row == usersModel.count - 1 {
                showTableViewSpinner()
                let query : String = {
                    var queryString = String()
                    if let searchText = searchController.searchBar.text {
                        queryString = searchText.isEmpty ? "a" : searchText
                    }
                    return queryString
                }()
                if pageNo < totalPages {
                    pageNo += 1
                fetchMoreUsers(query: query, page: pageNo)
                }
            }
        } else if tableView == self.recentSearchTable {
            
        }

    }
    
    // fetch more users
    func fetchMoreUsers (query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(page, query), pagination: true) { [weak self] (moreUsers) in
            DispatchQueue.main.async {
                if moreUsers.items.isEmpty == false {
                    self?.usersModel.append(contentsOf: moreUsers.items)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.footer
                }
            }
        }
    }
    
    // show spinner
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView == self.tableView {
            passedUsers = usersModel[indexPath.row]
            return indexPath
        } else if tableView == self.recentSearchTable {
            
        }
        return IndexPath()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
           return 60
        } else if tableView == self.recentSearchTable {
            return 50
        }
        return CGFloat()
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if tableView == self.tableView {
            let identifier = "\(String(describing: index))" as NSString
            return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
                
                let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                    let usersIndex = self.usersModel[indexPath.row]
                    let items = UsersDataBase(context: self.context)
                    items.userName = usersIndex.userName
                    items.userAvatar = usersIndex.userAvatar
                    items.userURL = usersIndex.userURL
                    try! self.context.save()
                }
                
                let safariAction = UIAction(
                    title: Titles.openInSafari,
                    image: UIImage(systemName: "link")) { _ in
                    let url = self.usersModel[indexPath.row].userURL
                    let vc = SFSafariViewController(url: URL(string: url)!)
                    self.present(vc, animated: true)
                }
                
                let shareAction = UIAction(
                    title: Titles.share,
                    image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    let avatarUrl = self.usersModel[indexPath.row].userAvatar
                    let url = self.usersModel[indexPath.row].userURL
                    let fileUrl = URL(string: avatarUrl)
                    let data = try? Data(contentsOf: fileUrl!)
                    let image = UIImage(data: data!)
                    let sheetVC = UIActivityViewController(activityItems: [image!,url], applicationActivities: nil)
                    HapticsManger.shared.selectionVibrate(for: .medium)
                    self.present(sheetVC, animated: true)
                }
                
                let saveImage = UIAction(
                    title: Titles.saveImage,
                    image: UIImage(systemName: "photo")) { _ in
                    let url = self.usersModel[indexPath.row].userAvatar
                    let fileUrl = URL(string: url)
                    let data = try? Data(contentsOf: fileUrl!)
                    let image = UIImage(data: data!)
                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                    HapticsManger.shared.selectionVibrate(for: .heavy)
                }
                
                return UIMenu(title: "", image: nil, children: [safariAction, bookmarkAction, saveImage, shareAction])
            }
        } else if tableView == self.recentSearchTable {
            
        }
     return UIContextMenuConfiguration()
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.recentSearchTable {
            let headerText = UILabel()
            switch section {
            case 0:
                if self.searchHistory.isEmpty == false {
                    headerText.text = "RECENT SEARCH"
                } else {
                    return nil
                }
            default:
                    break
            }
            return headerText.text
        } else if tableView == self.tableView {
            return nil
        }
        return String()
      }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == self.tableView {
            return .none
        } else if tableView == self.recentSearchTable {
            return .delete

        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // delete search record
            let item = searchHistory[indexPath.row]
            DataBaseManger.shared.Delete(returnType: SearchHistory.self, Delete: item)
            DataBaseManger.shared.Fetch(returnType: SearchHistory.self) { (history) in
                self.searchHistory = history
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

}
