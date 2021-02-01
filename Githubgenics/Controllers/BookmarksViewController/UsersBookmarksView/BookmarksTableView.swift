//
//  BookmarksTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension SavedUsersController {


override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookmarkedUsers.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.userSerchCell, for: indexPath) as? UsersSearchCell
    let  model = bookmarkedUsers[indexPath.row]
    cell?.CellData(with: model)
    return cell!
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let url = bookmarkedUsers[indexPath.row].html_url
    let vc = SFSafariViewController(url: URL(string: url!)!)
    present(vc, animated: true)
    
}

override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
}

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = bookmarkedUsers[indexPath.row]
            Delete().user(item: item) { (result) in
                self.bookmarkedUsers = result
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    


}
