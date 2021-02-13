//
//  RepostoiresTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension RepositoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.commitViewSegue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedRepository = repositories[indexPath.row]
        return indexPath
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.repositoriesCell, for: indexPath) as? ReposCell
        cell?.CellData(with: repositories[indexPath.row])
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell!.addGestureRecognizer(longPress)
        return cell!
    }
        
}


