//
//  table.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Foundation
import UIKit
import SafariServices

//MARK:- TableView DataSource

extension SearchViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userSerchCell, for: indexPath) as! UsersSearchCell
        cell.CellData(with: searchedUsers[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let IndexPath = searchedUsers[indexPath.row]
        let vc = SFSafariViewController(url: URL(string: IndexPath.userURL!)!)
        present(vc, animated: true)
        Save().lastSearch(login: IndexPath.userName!, avatar_url: IndexPath.userAvatar!, html_url: IndexPath.userURL!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

