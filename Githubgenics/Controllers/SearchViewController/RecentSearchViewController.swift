//
//  SearchHistoryContainer.swift
//  Githubgenics
//
//  Created by Ali Fayed on 23/01/2021.
//

import UIKit
import SafariServices

class RecentSearchViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    
    @IBOutlet weak var clearAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func clearAll(_ sender: UIButton) {
  
    }
    
    
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
    
    
    

//MARK:- CRUD Functions

    func createNewSearchHistoryItem (keyword: String) {
        let historyData = SearchHistory(context: context)
        historyData.keyword = keyword
        do {
            try context.save()
            fetchSearchHistory ()
        } catch {}
    }
    
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
    
}
//MARK:- tableView DataSource and Delegate

extension RecentSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchHistory.count
   }
   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = searchHistory[indexPath.row].keyword
       return cell
   }

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
}
//MARK:- collectionView DataSource and Delegate

extension RecentSearchViewController:  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
         print("Done")
        let url = lastSearch[indexPath.row].html_url
        let serverErrorURL = URL(string: "https://github.com")!
        let vc = SFSafariViewController(url: URL(string: url!) ?? serverErrorURL)
        present(vc, animated: true)
        
    }
    
}

