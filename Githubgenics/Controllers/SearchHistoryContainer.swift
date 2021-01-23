//
//  SearchHistoryContainer.swift
//  Githubgenics
//
//  Created by Ali Fayed on 23/01/2021.
//

import UIKit

class SearchHistoryContainer: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchHistory = [SearchHistory]()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAllData()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllData ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllData ()
    }
    
    
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row].keyword
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("done")
    }
    
    
    func fetchAllData () {
        do {
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        } catch {
            //error
        }
    }
    func savehistory (keyword: String) {
        let historyData = SearchHistory(context: context)
        historyData.keyword = keyword
        do {
            try context.save()
            fetchAllData ()
        } catch {}
    }
    
    func updateHistory (DataBase: SearchHistory, keyword: String)  {
        DataBase.keyword = keyword
        do {
            try context.save()
            fetchAllData ()
        } catch {
            
        }
    }
    
}
