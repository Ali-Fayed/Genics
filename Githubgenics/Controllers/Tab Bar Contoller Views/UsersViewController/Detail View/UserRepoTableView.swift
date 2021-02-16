//
//  SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices

extension DetailViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.repositoriesCell, for: indexPath) as! ReposCell
        cell.CellData(with: userRepository[indexPath.row])
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPress)
        cell.delegate = self
        cell.buttonAccessory()
        if starButton[indexPath.row] != nil {
            cell.accessoryView?.tintColor = starButton[indexPath.row]! ? .red : .lightGray
        } else {
            starButton[indexPath.row] = false
            cell.accessoryView?.tintColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.commitViewSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      selectedRepository = userRepository[indexPath.row]
      return indexPath
    }
}



extension DetailViewController : DetailViewCellDelegate {
    
    func didTapButton(cell: ReposCell, didTappedThe button: UIButton?) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryView?.tintColor == .red {
                cell.accessoryView?.tintColor = .lightGray
                starButton[indexPath.row] = false
            }
            else{
                HapticsManger.shared.selectionVibrate(for: .medium)
                cell.accessoryView?.tintColor = .red
                starButton[indexPath.row] = true
                let repository = self.userRepository[indexPath.row]
                Save().repository(repoName: repository.repositoryName, repoDescription: repository.repositoryDescription ?? "", repoProgrammingLanguage: repository.repositoryLanguage ?? "", repoURL: repository.repositoryURL, repoUserFullName: repository.repoFullName, repoStars: Float((repository.repositoryStars!)))
                        DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        saveStarState()
    }
}
