//
//  tb.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import CoreData



extension RecentSearchViewController:  UITableViewDataSource , UITableViewDelegate {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchHistory.count
}

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: K.searchHistoryCell, for: indexPath)
   cell.textLabel?.text = searchHistory[indexPath.row].keyword
    cell.accessoryType = .checkmark
//    cell.accessoryView = UIImageView(initWithImage:[UIImage imageNamed:"lock_icon.png"
//            [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)]
    cell.accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.backward"))
    
   return cell
    
}
//    cell.textLabel?.text = searchHistory[indexPath.row].keyword
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "collection", for: indexPath)
//        cell.textLabel?.text = "1"
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
          headerView.backgroundColor = UIColor(named: "labels")

          let sectionLabel = UILabel(frame: CGRect(x: 8, y: 28, width:
              tableView.bounds.size.width, height: tableView.bounds.size.height))
          sectionLabel.font = UIFont(name: "Helvetica", size: 12)
          sectionLabel.textColor = UIColor(named: "labels")
          sectionLabel.text = "RECENT SEARCHES"
          sectionLabel.sizeToFit()
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "delete.left") , for: .normal)
        button.imageView?.tintColor = UIColor(named: "labels")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.frame = CGRect(x: 370, y: 14, width: 62, height: 12)
        button.sizeToFit()
        button.addTarget(self, action: #selector(myClasspressed), for: .touchUpInside)
          headerView.addSubview(sectionLabel)
        headerView.addSubview(button)
          return headerView
    }
    

    @objc func myClasspressed () {
        print("here")
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: K.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: K.lastSearchEntity)
        let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)

        do {
            try context.execute(resetRequest)
            try context.execute(resetRequest2)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
            Fetch().self.searchHistory { (result) in
            self.searchHistory = result
            }
            Fetch().self.lastSearch { (result) in
                self.lastSearch = result
            }
        } catch {
            print ("There was an error")
        }
    }
    
    

    

 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
//    UsersListViewController.shared.searchBar.text = searchHistory[indexPath.row].keyword
    
}
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
       }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
}

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        tableView.beginUpdates()
        let item = searchHistory[indexPath.row]
        Delete().searchHistory(item: item) { (result) in
            self.searchHistory = result
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()

    }
}



}
