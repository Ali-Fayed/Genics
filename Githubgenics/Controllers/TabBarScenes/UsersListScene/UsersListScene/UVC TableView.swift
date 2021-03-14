//
//  UVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit

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
            let querySetup : String = {
                var query : String = "a"
                if searchBar.text == nil {
                    query = searchBar.text ?? ""
                }
                return query
            }()
            if pageNo < totalPages {
                pageNo += 1
            fetchMoreUsers(query: querySetup, page: pageNo)
            }
        }
    }
    
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
    
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            
            let mapAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                let usersIndex = self.usersModel[indexPath.row]
                let items = UsersDataBase(context: self.context)
                items.userName = usersIndex.userName
                items.userAvatar = usersIndex.userAvatar
                items.userURL = usersIndex.userURL
                try! self.context.save()
            }
            
            let shareAction = UIAction(
                title: Titles.url,
                image: UIImage(systemName: "link")) { _ in
                let url = self.usersModel[indexPath.row].userURL
                let vc = SFSafariViewController(url: URL(string: url)!)
                self.present(vc, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [mapAction, shareAction])
        }
    }
}
