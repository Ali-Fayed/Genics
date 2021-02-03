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

        
//        if userRepository[indexPath.row].done == false {
//            cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
//        } else {
//            cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)
//            userRepository[indexPath.row].done = true
//        }
        
        
             
        if checkmarks[indexPath.row] != nil {
            
            cell.accessoryType = checkmarks[indexPath.row]! ? .checkmark : .none
            if checkmarks[indexPath.row] == true {
                cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)
            }else {
                cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
            }
            

        } else {
            
            checkmarks[indexPath.row] = false
            cell.accessoryType = .none
            cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CommitSegue", sender: self)
    }
    
 
    
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      selectedRepository = userRepository[indexPath.row]
      return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let commitsViewController = segue.destination as? CommitsViewController else {
          return
        }
        commitsViewController.selectedRepository = selectedRepository
    }

    
}
extension DetailViewController : MyTableViewCellDelegate {
    
    func didTapButton(cell: ReposCell, didTappedThe button: UIButton?) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        print("we in \(index.row)")
        Save().repository(name: userRepository[index.row].repositoryName!, desc: userRepository[index.row].repositoryDescription ?? "", language: userRepository[index.row].repositoryLanguage ?? "", stars: userRepository[index.row].repositoryStars ?? 1, url: userRepository[index.row].repositoryURL!)
        
//         userRepository[index.row].done = !userRepository[index.row].done
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
 
        if let cell = tableView.cellForRow(at: index) {
            if cell.accessoryType == .checkmark {
                button?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
//                cell.accessoryType = .none
                checkmarks[index.row] = false
            }
            else{
                button?.setBackgroundImage(UIImage(named: "like"), for: .normal)
//                cell.accessoryType = .checkmark
                checkmarks[index.row] = true
            }
        }
  
        
        
//        if ((cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)) != nil) {
//            cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
//                checkmarks[index.row] = false
//            }
//            else{
//                cell.bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)
//                checkmarks[index.row] = true
//            }
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: checkmarks), forKey: "checkmarks")
        UserDefaults.standard.synchronize()
        
    }
    
    
    
}
