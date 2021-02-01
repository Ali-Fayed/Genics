//
//  UsersTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import UIKit


extension UsersListViewController {
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userCell, for: indexPath) as! UsersCell
        cell.CellData(with: users[indexPath.row])
        let longPress = UILongPressGestureRecognizer()
        cell.addGestureRecognizer(longPress)
        return cell
    }

    //MARK:- TableViev Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            fetchMoreFromUsersList()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            tableViewSpinner()
        }
    }
    
    func tableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [important])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Bookmark") { [weak self] (action, view, completion) in
     
        }
        action.image = #imageLiteral(resourceName: "like")
        action.backgroundColor = .gray
        return action
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailViewController {
            destnation.passedUser = users[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
