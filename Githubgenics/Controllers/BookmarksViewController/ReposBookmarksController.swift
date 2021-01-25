//
//  ReposBookmarksController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/01/2021.
//

import UIKit
import SafariServices
import CoreData

class ReposBookmarksController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var repobookmark = [SavedRepositories]()

    func fetchAllData () {
        do {
            repobookmark = try context.fetch(SavedRepositories.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ReposCell.nib(), forCellReuseIdentifier: "repocell")
        fetchAllData ()
        searchBar.delegate = self
        tableView.rowHeight = 120

    }
    
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repobookmark.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repocell", for: indexPath) as? ReposCell
        cell?.cellll(with: repobookmark[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = repobookmark[indexPath.row]
            deleteBookmarkedUser(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    
    func deleteBookmarkedUser(item: SavedRepositories) {
        context.delete(item)
        do {
            try context.save()
            fetchAllData()            
        } catch {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = repobookmark[indexPath.row].url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url! as! String) ?? serverErrorURL)
        DispatchQueue.main.async {
            tableView.isHidden = false
        }
        present(vc, animated: true)

    }
    
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            fetchAllData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                repobookmark = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
        
        
    }
    


}


//
extension ReposBookmarksController : UISearchDisplayDelegate {
    

}
