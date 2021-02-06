//
//  RepoTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension ReposBookmarksController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRepositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.repositoriesCell, for: indexPath) as? ReposCell
        cell?.CellData(with: savedRepositories[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = savedRepositories[indexPath.row]
            Delete().repository(item: item)  { (result) in
                self.savedRepositories = result
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
 
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let url = savedRepositories[indexPath.row].url
//        let vc = SFSafariViewController(url: URL(string: url! as! String)!)
//        DispatchQueue.main.async {
//            tableView.isHidden = false
//        }
//        present(vc, animated: true)
    performSegue(withIdentifier: "CommitSegue", sender: self)
    }
    
}
