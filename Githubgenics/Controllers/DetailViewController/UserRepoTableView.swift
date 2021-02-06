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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userRepositoryCell, for: indexPath) as! ReposCell
        cell.CellData(with: userRepository[indexPath.row])
        cell.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommitSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "CommitSegue" {
        guard let commitsViewController = segue.destination as? CommitsViewController else {
          return
        }
        commitsViewController.selectedRepositorry = selectedRepository
      }
    }
 
    
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      selectedRepository = userRepository[indexPath.row]
      return indexPath
    }
    
}
extension DetailViewController : MyTableViewCellDelegate {
    
    func didTapButton(cell: ReposCell, didTappedThe button: UIButton?) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        Save().repository(name: userRepository[index.row].repositoryName!, desc: userRepository[index.row].repositoryDescription ?? "", language: userRepository[index.row].repositoryLanguage ?? "", stars: userRepository[index.row].repositoryName, url: userRepository[index.row].repositoryURL!, fulName: userRepository[index.row].fullName)
                DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    

    
}
