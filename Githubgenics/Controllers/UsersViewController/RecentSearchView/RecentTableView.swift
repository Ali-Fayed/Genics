//
//  tb.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit



extension RecentSearchViewController:  UITableViewDataSource , UITableViewDelegate {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return searchHistory.count
}

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.searchHistoryCell, for: indexPath)
   cell.textLabel?.text = searchHistory[indexPath.row].keyword
   return cell
}
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "collection", for: indexPath)
//        cell.textLabel?.text = "1"
//    }


 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    UsersListViewController().searchBar.text = searchHistory[indexPath.row].keyword
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
