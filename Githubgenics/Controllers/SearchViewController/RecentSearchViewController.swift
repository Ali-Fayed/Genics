//
//  SearchHistoryContainer.swift
//  Githubgenics
//
//  Created by Ali Fayed on 23/01/2021.
//

import UIKit
import SafariServices
import CoreData

class RecentSearchViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    
    @IBOutlet weak var clearAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSearchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSearchHistory ()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSearchHistory ()
    }
    
    
//MARK:- DataBase Methods
    
    func fetchSearchHistory () {
        do {
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            lastSearch = try context.fetch(LastSearch.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        } catch {
            
        }
    }
    
    func deleteSearchHistoryItem (item: SearchHistory) {
        context.delete(item)
        do {
            try context.save()
            fetchSearchHistory()

        } catch {
            
        }
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearch")
        let resetRequest = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetRequest2 = NSBatchDeleteRequest(fetchRequest: resetLastSearch)

        do {
            try context.execute(resetRequest)
            try context.execute(resetRequest2)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            DispatchQueue.global(qos: .userInteractive).async {
                self.fetchSearchHistory()
            }
        } catch {
            print ("There was an error")
        }
    }
}


    //MARK:- TableView DataSource

  extension RecentSearchViewController:  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchHistory.count
   }
   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = searchHistory[indexPath.row].keyword
       return cell
   }

}


      //MARK:- TableView Delegate
    
  extension RecentSearchViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
      func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = searchHistory[indexPath.row]
            deleteSearchHistoryItem(item: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

        }
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destnation = segue.destination as? SearchViewController {
                destnation.passedKeys = searchHistory[(tableView.indexPathForSelectedRow?.row)!]
            }
    }

  }
//MARK:- CollectionView DataSource

extension RecentSearchViewController:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SearchHistoryCollectionViewCell
        cell!.login.text = lastSearch[indexPath.row].login
        let url = lastSearch[indexPath.row].avatar_url
        cell!.avatar.kf.setImage(with: URL(string: url!), placeholder: nil, options: [.transition(.fade(0.7))])
        cell!.avatar.contentMode = .scaleAspectFill
        cell!.avatar.layer.masksToBounds = false
        cell!.avatar.layer.cornerRadius = cell!.avatar.frame.height/2
        cell!.avatar.clipsToBounds = true
        return cell!
    }
    
  
    
}

//MARK:- CollectionView Delegate

extension RecentSearchViewController:  UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
         print("Done")
        let url = lastSearch[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
        present(vc, animated: true)
        
    }
}

