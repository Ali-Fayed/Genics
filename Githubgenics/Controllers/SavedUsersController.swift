//
//  SavedUsersController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit
import Kingfisher
import CoreData
import SafariServices

class SavedUsersController: UITableViewController , UISearchBarDelegate {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
    var bookmarkedUsers = [UsersDataBase]()
    

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: UsersSearchCell.identifier)
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Bookmarks".localized()
        fetchBookmarks ()
    }
    
    
    //MARK:- CRUD Methods
    
    
    func fetchBookmarks () {
        do {
            bookmarkedUsers = try context.fetch(UsersDataBase.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func deleteBookmarkedUser(item: UsersDataBase) {
        context.delete(item)
        do {
            try context.save()
            fetchBookmarks()
            
        } catch {
            
        }
    }
    
    func loadItems(with request: NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest(), predicate: NSPredicate? = nil) {
        do {
            bookmarkedUsers = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK:- tableView DataSource and Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedUsers.count
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = bookmarkedUsers[indexPath.row]
            deleteBookmarkedUser(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = bookmarkedUsers[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
        present(vc, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersSearchCell.identifier, for: indexPath) as? UsersSearchCell
        let  model = bookmarkedUsers[indexPath.row]
        cell?.UserTitleLabel.text = model.login
        let url = model.avatar_url!
        cell?.UserAvatar.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        cell?.UserAvatar.contentMode = .scaleAspectFill
        cell?.UserAvatar.layer.masksToBounds = false
        cell?.UserAvatar.layer.cornerRadius = (cell?.UserAvatar.frame.height)!/2
        cell?.UserAvatar.clipsToBounds = true
        return cell!
    }
    
    
}


//MARK:- UISearchBar Delegate

extension SavedUsersController : UISearchDisplayDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            loadItems()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest()
            request.predicate = NSPredicate(format: "login CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "login", ascending: true)]
            do {
                bookmarkedUsers = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
        
        
    }
}


