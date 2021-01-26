//
//  ReposBookmarksController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/01/2021.
//

import UIKit
import SafariServices
import CoreData

class ReposBookmarksController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedRepositories = [SavedRepositories]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!


    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: "repocell")
        fetchSavedRepositories ()
        searchBar.delegate = self
        tableView.rowHeight = 120
        navigationItem.title = "Repositories".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    

    // MARK: - TableView DataSource

       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRepositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repocell", for: indexPath) as? ReposCell
        cell?.CellData(with: savedRepositories[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
    
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = savedRepositories[indexPath.row]
            deleteBookmarkedRepositories(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = savedRepositories[indexPath.row].url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url! as! String) ?? serverErrorURL)
        DispatchQueue.main.async {
            tableView.isHidden = false
        }
        present(vc, animated: true)

    }
    
    //MARK:- DataBase Methods
    
    func deleteBookmarkedRepositories(item: SavedRepositories) {
        context.delete(item)
        do {
            try context.save()
            fetchSavedRepositories()            
        } catch {
            
        }
    }
    
 
    func fetchSavedRepositories () {
        do {
            savedRepositories = try context.fetch(SavedRepositories.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }

}

//MARK:- UISearchBar Delegate

extension ReposBookmarksController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            fetchSavedRepositories()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                savedRepositories = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
}
