//
//  RepositoriesViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    // data models
    var publicRepositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    // two search bar for animating (check search bar page)
    lazy var reposSearchBar:UISearchBar = UISearchBar()
    lazy var repoSearchBarHeader:UISearchBar = UISearchBar()
    let longPress = UILongPressGestureRecognizer()
    // long press and persistentContainer context
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    // before search label
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForRepos
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loading indicator
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        // tableview
        tableView.addSubview(refreshControl)
        tableView.addGestureRecognizer(longPress)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.rowHeight = 60
        // search label subview
        view.addSubview(searchLabel)
        // hide label and zero opacity when start
        searchLabel.isHidden = true
        self.searchLabel.alpha = 0.0
        // title and seachbar
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        renderSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // return tab bar after search
        self.tabBarController?.tabBar.isHidden = false
        // main screen repos
        renderAndDisplayBestSwiftRepositories ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.tableHeaderView = self.repoSearchBarHeader
        tableView.tableFooterView = UIView()
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
    }
    
    // layout and framing
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
}
