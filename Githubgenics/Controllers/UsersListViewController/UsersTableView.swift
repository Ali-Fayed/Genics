//
//  UsersTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import SafariServices
import UIKit

extension UsersListViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // generic function to reduce dequeue new cell code
        let cell = tableView.dequeue() as UsersCell
        // fetch cell data from cell class
        cell.CellData(with: users[indexPath.row])
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Segues.detailViewSegue, sender: self)
            let usersModel = users[indexPath.row]
            let items = LastSearch(context: self.context)
            items.userName = usersModel.userName
            items.userAvatar = usersModel.userAvatar
            items.userURL = usersModel.userURL
            try! self.context.save()

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // pagination and fetch more
        if indexPath.row == users.count - 1 {
            showTableViewSpinner()
            fetchMoreUsers ()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // pass model to passedUsers var
        passedUsers = users[indexPath.row]
        return indexPath
    }
}
