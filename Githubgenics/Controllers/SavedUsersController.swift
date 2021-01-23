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

class SavedUsersController: UITableViewController , UISearchBarDelegate , UISearchDisplayDelegate {
     
    @IBOutlet weak var searchBar: UISearchBar!

    var APISaves = [UsersDataBase]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersSearchCell.nib(), forCellReuseIdentifier: UsersSearchCell.identifier)
//        fetchAllData ()
        searchBar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Bookmarks".localized()
        fetchAllData ()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchAllData ()
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APISaves.count
    }
    
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
                   APISaves = try context.fetch(request)
               } catch {
                   print(error)
               }
               tableView.reloadData()
            }

            
        }
    
     override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = APISaves[indexPath.row]
            deleteItem(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = APISaves[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
        present(vc, animated: true)
        
    }
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersSearchCell.identifier, for: indexPath) as? UsersSearchCell
       let  model = APISaves[indexPath.row]
        cell?.UserTitleLabel.text = model.login
        let url = model.avatar_url!
        cell?.UserAvatar.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(.fade(0.7))])
        cell?.UserAvatar.contentMode = .scaleAspectFill
        cell?.UserAvatar.layer.masksToBounds = false
        cell?.UserAvatar.layer.cornerRadius = (cell?.UserAvatar.frame.height)!/2
        cell?.UserAvatar.clipsToBounds = true
        return cell!
    }
    
    
    
    func loadItems(with request: NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest(), predicate: NSPredicate? = nil) {
    
        do {
            APISaves = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    

    
    func fetchAllData () {
        do {
            APISaves = try context.fetch(UsersDataBase.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    
    func saveNewSearchHistoryWord (login: String , avatar_url: String) {
        let DataParameters = UsersDataBase(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        do {
            try context.save()
            fetchAllData()
        } catch {
            
        }
    }
    
    
    func updateSearchHistory (DataParameters: UsersDataBase, SaveData: String)  {
        DataParameters.login = SaveData
        DataParameters.avatar_url = SaveData
        do {
            try context.save()
            fetchAllData()
        } catch {
            
        }
    }
    
    func deleteItem(item: UsersDataBase) {
        context.delete(item)
        do {
            try context.save()
            fetchAllData()

        } catch {
            
        }
    }
    
    
}


