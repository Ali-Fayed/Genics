//
//  BookmarksViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/01/2021.
//

import UIKit
import CoreData
import XCoordinator

class BookmarksViewController: CommonViews {
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - @Props
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: BookmarksViewModel = {
        return BookmarksViewModel ()
    }()
    var router: UnownedRouter<BookmarkRoute>?
    //MARK: - UIcomponent
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForBookmarks
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        initViewModel()
        viewModel.noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - ViewMethods
    func initView() {
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        conditionLabel.text = Titles.noBookmarks
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        setupSearchController(search: searchController)
        view.addSubview(searchLabel)
        view.addSubview(conditionLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        viewModel.noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    func initViewModel() {
        viewModel.renderViewData(tableView: tableView)
    }
}
//MARK: - SearchBar
extension BookmarksViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchLabel.isHidden = true
        viewModel.searchFromDB(tableView: tableView, searchController: searchController)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.renderViewData(tableView: tableView)
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.searchLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}
