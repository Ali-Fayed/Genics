//
//  SearchHistoryContainer.swift
//  Githubgenics
//
//  Created by Ali Fayed on 23/01/2021.
//

import UIKit
import SafariServices
import CoreData

class RecentSearchViewController:  UIViewController  {
    
    // data models
    var searchHistory = [SearchHistory]()
    var lastSearch = [LastSearch]()
    // label appear before search
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForUsers
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBAction func removeAll(_ sender: UIButton) {
        excute ()
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // config recent label in header view (Check StoryBoard)
        recentLabel.font = UIFont(name: "Helvetica", size: 12)
        recentLabel.text = Titles.searchHistory
        recentLabel.sizeToFit()
        // hide before search label when load
        searchLabel.isHidden = true
        tableView.addSubview(refreshControl)
        // put footer in table to disable unused seprators
        tableView.tableFooterView = UIView()
        tableView.registerCellNib(cellClass: SearchHistoryCell.self)
        tableView.sectionHeaderHeight = 120
        view.addSubview(searchLabel)
        // hide or display the view with some conditions
        renderRecentHistoryHiddenConditions ()
        // render database models data
        renderViewData ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        renderRecentHistoryHiddenConditions ()
        renderViewData()
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    //MARK:- Functions
    
    func renderViewData () {
        DataBaseManger().Fetch(returnType: LastSearch.self) { [weak self] (result) in
            self?.lastSearch = result
            self?.collectionView.reloadData()
            
            DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
                self?.searchHistory = result
                self?.tableView.reloadData()
            }
        }
    }
    
    // Handle DB Excution
    func excute () {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.tableView.isHidden = true
                self.searchLabel.isHidden = false
            }
            renderViewData ()
        } catch {
            //
        }
    }
    
    // Handle History View Conditions
    func renderRecentHistoryHiddenConditions () {
        if lastSearch.isEmpty == true {
            tableView.isHidden = true
            searchLabel.isHidden = false
        } else {
            tableView.isHidden = false
            searchLabel.isHidden = true
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    
}

//MARK:- recent words tableView

extension RecentSearchViewController:  UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SearchHistoryCell
        cell.CellData(with: searchHistory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard.init(name: Storyboards.tabBar , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.usersListViewID) as? UsersViewController
        let history = searchHistory[indexPath.row].keyword
        DispatchQueue.main.async {
            vc?.searchBar.text = history
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // delete search record
            let item = searchHistory[indexPath.row]
            DataBaseManger.shared.Delete(returnType: SearchHistory.self, Delete: item)
            DataBaseManger.shared.Fetch(returnType: SearchHistory.self) { (history) in
                self.searchHistory = history
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}


//MARK:- lastSearch Collection

extension RecentSearchViewController:  UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastSearchCollectionCell.lastSearchCell, for: indexPath) as? LastSearchCollectionCell
        cell!.CellData(with: lastSearch[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let url = lastSearch[indexPath.row].userURL
        let vc = SFSafariViewController(url: URL(string: url!)!)
        present(vc, animated: true)
    }

}
