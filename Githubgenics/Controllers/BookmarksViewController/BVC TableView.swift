//
//  BookmarksTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension BookmarksViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bookmarkedUsers.count
        default:
            return savedRepositories.count
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeue() as UsersCell
            let  model = bookmarkedUsers[indexPath.row]
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            cell.addGestureRecognizer(longPress)
            cell.CellData(with: model)
            return cell
        default:
            let cell = tableView.dequeue() as ReposCell
            cell.CellData(with: savedRepositories[indexPath.row])
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            cell.addGestureRecognizer(longPress)
            return cell
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            guard let url = bookmarkedUsers[indexPath.row].userURL
            else { return }
            let vc = SFSafariViewController(url: URL(string: url)!)
            present(vc, animated: true)
        default:
            performSegue(withIdentifier: Segues.commitViewSegue, sender: self)

        }
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case 0:
            break
        default:
            passedRepo = savedRepositories[indexPath.row]
        }
        return indexPath
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
            headerText.textAlignment = .center
            headerText.text = "Users"
        default:
            headerText.textAlignment = .center
            headerText.text = "Repositories"
        }
        return headerText.text
    }
        
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                let item = bookmarkedUsers[indexPath.row]
                DataBaseManger().Delete(returnType: UsersDataBase.self, Delete: item)
                DataBaseManger().Fetch(returnType: UsersDataBase.self) { (users) in
                    self.bookmarkedUsers = users
                }
            default:
                let item = savedRepositories[indexPath.row]
                DataBaseManger().Delete(returnType: SavedRepositories.self, Delete: item)
                DataBaseManger().Fetch(returnType: SavedRepositories.self) { (repos) in
                    self.savedRepositories = repos
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
