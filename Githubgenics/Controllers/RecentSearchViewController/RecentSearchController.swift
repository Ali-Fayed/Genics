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
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // config recent label in header view (Check StoryBoard)
        recentLabel.font = UIFont(name: "Helvetica", size: 12)
        recentLabel.text = Titles.searchHistory
        recentLabel.sizeToFit()
        // hide before search label when load
        searchLabel.isHidden = true
        // put footer in table to disable unused seprators
        tableView.tableFooterView = UIView()
        self.tableView.sectionHeaderHeight = 120
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
    
}
