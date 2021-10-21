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
import RxSwift
import RxCocoa

class UsersViewController: CommonViews {
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel = UsersViewModel()
    var query : String = ""
    let bag = DisposeBag()
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBAction func removeAll(_ sender: UIButton) {
        viewModel.excute(tableView: recentSearchTable, collectionView: collectionView, label: conditionLabel)
        HapticsManger.shared.selectionVibrate(for: .heavy)
    }
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - UI Functions
    func initView () {
        setupConditionLabel(conditionLabel: conditionLabel)
        setupTableView(tableView: tableView)
        setupSearchHistoryTable(tableView: recentSearchTable)
        renderRecentHistoryHiddenConditions()
        dismissButton()
        bindUsersListTableView()
        bindLastSearchCollectionView()
        bindSearchHistoryTableView ()
    }
    @objc override func dismissView () {
        viewModel.router?.trigger(.dismiss)
    }
    func setupConditionLabel(conditionLabel: UILabel) {
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.searchForUsers
        conditionLabel.isHidden = true
    }
    func setupTableView(tableView: UITableView) {
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
    }
    func setupSearchHistoryTable(tableView: UITableView) {
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        tableView.isHidden = true
    }
    func initViewModel () {
        loadingSpinner.show(in: view)
        viewModel.recentSearchData()
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.fetchUsers(query: "a")
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            navigationItem.title = Titles.usersViewTitle
        } else {
            viewModel.fetchUsers(query: query)
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
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
}
//MARK: - SearchBar
extension UsersViewController: UISearchBarDelegate  {
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.viewModel.pageNo = 1
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
            self.viewModel.recentSearchData()
        }
    }
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.conditionLabel.isHidden = true
        guard let query = searchBar.text else { return }
        viewModel.fetchUsers(query: query)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 0.0
        })
    }
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchUsers(query: "a")
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.recentSearchTable.isHidden = true
            self.tableView.isHidden = false
            self.loadingSpinner.dismiss()
            self.recentSearchTable.reloadData()
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
//MARK: - CollectionView
extension UsersViewController {
    func bindLastSearchCollectionView () {
        /// lastSearchitems dataSource
        viewModel.lastSearchitems.bind(to: collectionView.rx.items(cellIdentifier: "LastSearchCollectionCell", cellType: LastSearchCollectionCell.self)) { row, model, cell  in
            cell.cellData(with: model)
        }.disposed(by: bag)
        /// didSelectRow
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.collectionView.deselectItem(at: indexPath, animated: true)
            self?.viewModel.router?.trigger(.lastSearch(indexPath: indexPath))
        }).disposed(by: bag)
    }
}
