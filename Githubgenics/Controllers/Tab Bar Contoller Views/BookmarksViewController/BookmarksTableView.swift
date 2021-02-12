//
//  BookmarksTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension BookmarksViewController {
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (savedRepositories.count + bookmarkedUsers.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < bookmarkedUsers.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.usersCell, for: indexPath) as? UsersCell
            let  model = bookmarkedUsers[indexPath.row]
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            cell!.addGestureRecognizer(longPress)
            cell?.CellData(with: model)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.repositoriesCell, for: indexPath) as? ReposCell
            cell?.CellData(with: savedRepositories[indexPath.row - bookmarkedUsers.count])
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            cell!.addGestureRecognizer(longPress)
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < bookmarkedUsers.count {
            let url = bookmarkedUsers[indexPath.row].userURL
            let vc = SFSafariViewController(url: URL(string: url!)!)
            present(vc, animated: true)
        } else {
            let url2 = savedRepositories[indexPath.row - bookmarkedUsers.count].repoURL
            let vc = SFSafariViewController(url: URL(string: url2!)!)
            present(vc, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if indexPath.row < bookmarkedUsers.count {
                let item = bookmarkedUsers[indexPath.row]
                Delete().user(item: item) { (result) in
                    self.bookmarkedUsers = result
                }
            } else {
                let item = savedRepositories[indexPath.row - bookmarkedUsers.count]
                Delete().repository(item: item)  { (result) in
                    self.savedRepositories = result
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < bookmarkedUsers.count {
            return 60
        } else {
            return 110
        }
    }
    
}
