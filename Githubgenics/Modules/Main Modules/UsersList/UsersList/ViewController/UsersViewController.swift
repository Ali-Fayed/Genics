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
    let bag = DisposeBag()
    //MARK: - IBOutlet
    @IBOutlet weak var usersListTableView: UITableView!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UIView!
    @IBAction func removeAll(_ sender: UIButton) {
        viewModel.excute(tableView: recentSearchTableView, collectionView: collectionView, label: conditionLabel)
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
        setupTableView(tableView: usersListTableView)
        setupSearchHistoryTable(tableView: recentSearchTableView)
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
        viewModel.fetchDataBaseData()
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.fetchUsers(query: "T")
            searchController.searchBar.delegate = self
            setupSearchController(search: searchController)
            navigationItem.title = Titles.usersViewTitle
        } else {
            viewModel.fetchUsers(query: viewModel.query)
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
    }
    func renderRecentHistoryHiddenConditions () {
        if recentSearchTableView.isHidden == true , searchController.searchBar.text?.isEmpty == false {
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
                self.usersListTableView.isHidden = true
            } else {
                self.usersListTableView.isHidden = false
                self.conditionLabel.isHidden = true
            }
            if self.viewModel.searchHistory.isEmpty == true {
                self.recentSearchTableView.isHidden = true
            } else {
                self.recentSearchTableView.isHidden = false
            }
            if self.searchController.searchBar.text?.isEmpty == true , self.viewModel.lastSearch.isEmpty == true , self.viewModel.searchHistory.isEmpty == true{
                self.conditionLabel.isHidden = false
            } else {
                self.conditionLabel.isHidden = true
            }
            self.loadingSpinner.dismiss()
            self.viewModel.fetchDataBaseData()
        }
    }
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.conditionLabel.isHidden = true
        guard let query = searchBar.text else { return }
        viewModel.fetchUsers(query: query)
        UIView.animate(withDuration: 0.0, animations: {
            self.usersListTableView.alpha = 1.0
            self.recentSearchTableView.alpha = 0.0
        })
    }
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchUsers(query: "a")
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.recentSearchTableView.isHidden = true
            self.usersListTableView.isHidden = false
            self.loadingSpinner.dismiss()
            self.recentSearchTableView.reloadData()
            self.conditionLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.usersListTableView.alpha = 1.0
            self.recentSearchTableView.alpha = 1.0
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
        viewModel.lastSearchModelObservable
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: LastSearchCollectionCell.self), cellType: LastSearchCollectionCell.self)) { row, lastSearch, cell  in
                cell.cellData(with: lastSearch)
            }.disposed(by: bag)
        /// didSelectRow
        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(LastSearch.self))
            .bind { [weak self] indexPath, lastSearch in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
                let safariVC = SFSafariViewController(url: URL(string: lastSearch.userURL!)!)
                self?.present(safariVC, animated: true)
            }.disposed(by: bag)
    }
}
