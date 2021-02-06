//
//  exTableView.swift
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
       return 120
   }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommitSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.repositoriesCell, for: indexPath) as? ReposCell
        cell?.CellData(with: repositories[indexPath.row])
        return cell!
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [important])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Bookmark") { [self] (action, view, completion) in
            let index = repositories[indexPath.row]
            Save().repository(name: index.repositoryName, desc: index.repositoryDescription ?? "", language: index.repositoryLanguage ?? "", stars: index.repositoryName, url: index.repositoryURL, fulName: index.fullName)
        }
        action.image = #imageLiteral(resourceName: "like")
        action.backgroundColor = .gray
        return action
    }
}

// MARK: - UITableViewDeletage
extension RepositoriesViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedRepository = repositories[indexPath.row]
    return indexPath
  }
}

// MARK: - Handling Segue
extension RepositoriesViewController {
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CommitSegue" {
      guard let commitsViewController = segue.destination as? CommitsViewController else {
        return
      }
      commitsViewController.selectedRepository = selectedRepository
    }
  }
}
