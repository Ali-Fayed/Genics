//
//  UsersViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import SafariServices
import JGProgressHUD
import CoreData

class UsersViewController: CommonViews {
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: UsersViewModel = {
        return UsersViewModel()
    }()
    var query : String = ""
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    
    @IBAction func removeAll(_ sender: UIButton) {
        viewModel.excute(tableView: recentSearchTable, collectionView: collectionView, label: conditionLabel)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        recentSearchTable.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - UI Functions
    func initView () {
        tabBarItem.title = Titles.usersViewTitle
        conditionLabel.text = Titles.searchForUsers
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        recentSearchTable.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        recentSearchTable.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.isHidden = true
        recentSearchTable.isHidden = true
        handleViewStyle ()
        renderRecentHistoryHiddenConditions()
        loadingSpinner.show(in: view)
    }
    func initViewModel () {
        viewModel.recentSearchData(collectionView: collectionView, tableView: recentSearchTable)
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: "a")
        } else {
            viewModel.fetchUsers(tableView: self.tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: query)
        }
    }
    func renderRecentHistoryHiddenConditions () {
        if recentSearchTable.isHidden == true , searchController.searchBar.text?.isEmpty == false {
            conditionLabel.isHidden = false
        } else {
            conditionLabel.isHidden = true
        }
        if viewModel.lastSearch.isEmpty == true , viewModel.searchHistory.isEmpty == true {
            conditionLabel.isHidden = true
        }
    }
    func handleViewStyle () {
        if searchController.searchBar.text?.isEmpty == true {
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            title = Titles.usersViewTitle
        } else {
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
    }
}
//MARK: - SearchBar
extension UsersViewController: UISearchBarDelegate  {
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.viewModel.pageNo = 1
            self.tableView.reloadData()
            self.recentSearchTable.reloadData()
            if self.searchController.searchBar.text?.isEmpty == true {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
                self.conditionLabel.isHidden = true
            }
            if self.viewModel.searchHistory.isEmpty == true {
                self.recentSearchTable.isHidden = true
            } else {
                self.recentSearchTable.isHidden = false
            }
            if self.searchController.searchBar.text?.isEmpty == true , self.viewModel.lastSearch.isEmpty == true , self.viewModel.searchHistory.isEmpty == true{
                self.conditionLabel.isHidden = false
            } else {
                self.conditionLabel.isHidden = true
            }
            self.loadingSpinner.dismiss()
            self.viewModel.recentSearchData(collectionView: self.collectionView, tableView: self.recentSearchTable)
        }
    }
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.conditionLabel.isHidden = true
        self.tableView.reloadData()
        guard let query = searchBar.text else { return }
        viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: query)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 0.0
        })
    }
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: "a")
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.recentSearchTable.isHidden = true
            self.tableView.isHidden = false
            self.loadingSpinner.dismiss()
            self.recentSearchTable.reloadData()
            self.collectionView.reloadData()
            self.conditionLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 1.0
        })
    }
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.saveSearchWord(text: text)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}
//MARK: - Collection
extension UsersViewController:  UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfLastSearchCells
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastSearchCollectionCell.lastSearchCell, for: indexPath) as? LastSearchCollectionCell
        cell!.cellData(with: viewModel.getLastSearchViewModel(at: indexPath))
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.router?.trigger(.lastSearch(indexPath: indexPath))
    }
}
