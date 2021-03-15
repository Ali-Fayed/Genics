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
        return usersModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // generic function to reduce dequeue new cell code
        let cell = tableView.dequeue() as UsersCell
        cell.CellData(with: usersModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard.init(name: Storyboards.detail , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.detailViewControllerID) as? PublicUserProfileViewController
        vc?.passedUser = passedUsers
        self.navigationController?.pushViewController(vc!, animated: true)
        // check for search bar in active or not to save history in collection
        if tableView.tableHeaderView == nil {
            let model = usersModel[indexPath.row]
            let items = LastSearch(context: self.context)
            items.userName = model.userName
            items.userAvatar = model.userAvatar
            items.userURL = model.userURL
            try! self.context.save()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == usersModel.count - 1 {
            showTableViewSpinner()
            let query : String = {
                var queryString = String()
                if let searchText = searchBar.text {
                    queryString = searchText.isEmpty ? "a" : searchText
                }
                return queryString
            }()
            if pageNo < totalPages {
                pageNo += 1
            fetchMoreUsers(query: query, page: pageNo)
            }
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
        passedUsers = usersModel[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
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
    }
}
