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
    lazy var viewModel: UsersViewModel = {
        return UsersViewModel()
    }()
    let bag = DisposeBag()
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
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - UI Functions
    func initView () {
        conditionLabel.text = Titles.searchForUsers
        view.addSubview(conditionLabel)
        handleViewStyle ()
        renderRecentHistoryHiddenConditions()
        dismissButton()
        initTableViewAndCollectioView ()
        searchBarInit ()
    }
    @objc override func dismissView () {
        viewModel.router?.trigger(.dismiss)
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
//MARK: - usersList tableView
extension UsersViewController {
    func bindUsersListTableView() {
        viewModel.fetchUsers(query: "a")
        /// usersListTableView rowHeight
        tableView.rx.rowHeight.onNext(60)
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        tableView.isHidden = true
        loadingSpinner.show(in: view)
        tableView.addSubview(refreshControl)
        /// usersListTableView dataSource
        viewModel.usersListItems.bind(to: tableView.rx.items(cellIdentifier: "UsersTableViewCell", cellType: UsersTableViewCell.self)) {[weak self] row, model, cell  in
            self?.viewModel.passedUsers = model
            cell.cellData(with: (self?.viewModel.passedUsers)!)
            self?.tableView.isHidden = false
            self?.loadingSpinner.dismiss()
        }.disposed(by: bag)
        
        /// didSelectRow
        tableView.rx.modelSelected(User.self).bind { [weak self] result in
            self?.viewModel.router?.trigger(.publicUserProfile(user: result))
            print(result)
        }.disposed(by: bag)
        /// selectedItem
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            if self?.searchController.searchBar.text?.isEmpty == false {
                self?.viewModel.saveToLastSearch(indexPath: indexPath)
            }
        }).disposed(by: bag)
        /// prefetchRows delete
        tableView.rx.prefetchRows.subscribe(onNext: { [self] indexPaths in
            for indexPath in indexPaths {
                self.showTableViewSpinner(tableView: self.tableView)
                self.viewModel.fetchMoreUsers(indexPath: indexPath, searchController: searchController)
            }
        }).disposed(by: bag)
    }
    //MARK: - searchHistory tableView
    func bindSearchHistoryTableView () {
        viewModel.fetchRecentSearch()
        /// recentSearchTable rowHeight
        recentSearchTable.isHidden = true
        recentSearchTable.rx.rowHeight.onNext(50)
        recentSearchTable.tableFooterView = tableFooterView
        recentSearchTable.addSubview(refreshControl)
        /// searchHistory dataSource
        viewModel.searchHistoryitems.bind(to: recentSearchTable.rx.items(cellIdentifier: "SearchHistoryCell", cellType: SearchHistoryCell.self)) { [weak self] row, model, cell  in
            cell.cellData(with: model)
            self?.viewModel.searchHistory = [model]
        }.disposed(by: bag)
        /// searchHistory delete
        recentSearchTable.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            self?.recentSearchTable.beginUpdates()
            self?.viewModel.deleteAndFetchRecentTableData(indexPath: indexPath)
            self?.recentSearchTable.deleteRows(at: [indexPath], with: .fade)
            self?.recentSearchTable.endUpdates()
        }).disposed(by: bag)
        /// searchHistory headerTitle
        if viewModel.searchHistory.isEmpty == false {
            let headerText = UILabel()
            headerText.text = Titles.recentSearch
            recentSearchTable.rx.tableHeaderView.onNext(headerText)
        }
    }
    //MARK: - lastSearch collectionView
    func bindLastSearchCollectionView () {
        viewModel.fetchlastSearch()
        /// lastSearchitems dataSource
        viewModel.lastSearchitems.bind(to: collectionView.rx.items(cellIdentifier: "LastSearchCollectionCell", cellType: LastSearchCollectionCell.self)) {[weak self] row, model, cell  in
            cell.cellData(with: model)
            self?.viewModel.lastSearch = [model]
        }.disposed(by: bag)
        /// didSelectRow
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.collectionView.deselectItem(at: indexPath, animated: true)
            self?.viewModel.router?.trigger(.lastSearch(indexPath: indexPath))
        }).disposed(by: bag)
    }
    //MARK: - callers
    func initTableViewAndCollectioView () {
        bindUsersListTableView()
        bindSearchHistoryTableView()
        bindLastSearchCollectionView()
    }
}

//MARK: - SearchBar
extension UsersViewController: UISearchBarDelegate  {
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarInit () {
        conditionLabel.isHidden = true
        /// excute when press  searchBar
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in
            print("textDidBeginEditing")
            self?.tableView.isHidden = true
            self?.recentSearchTable.isHidden = false
            self?.collectionView.isHidden = true
            self?.conditionLabel.isHidden = false
        }).disposed(by: bag)
        /// excute when press searchBar when change search text
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { _ in
            print("textDidChange")
            guard let text = self.searchController.searchBar.text else { return }
//            self.viewModel.fetchUsers(query: text)
            self.conditionLabel.isHidden = true
            self.recentSearchTable.isHidden = true
        }).disposed(by: bag)
        /// excute when press searchBar when search text is not nill
        searchController.searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] in
            print("searchButtonClicked")
            guard let text = self?.searchController.searchBar.text else { return }
            self?.viewModel.saveSearchWord(text: text)
        }).disposed(by: bag)
        /// excute when press cancel searchBar
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] in
            print("cancelButtonClicked")
            self?.searchController.searchBar.text = nil
            self?.recentSearchTable.isHidden = true
            self?.tableView.isHidden = false
            self?.loadingSpinner.dismiss()
            self?.conditionLabel.isHidden = true
        }).disposed(by: bag)
    }
    //    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //        DispatchQueue.main.async {
    //            if self.searchController.searchBar.text?.isEmpty == true {
    //                self.tableView.isHidden = true
    //            } else {
    //                self.tableView.isHidden = false
    //                self.conditionLabel.isHidden = true
    //            }
    //
    //            if self.viewModel.searchHistory.isEmpty == true {
    //                self.recentSearchTable.isHidden = true
    //            } else {
    //                self.recentSearchTable.isHidden = false
    //            }
    //
    //            if self.searchController.searchBar.text?.isEmpty == true , self.viewModel.lastSearch.isEmpty == true , self.viewModel.searchHistory.isEmpty == true{
    //                self.conditionLabel.isHidden = false
    //            } else {
    //                self.conditionLabel.isHidden = true
    //            }
    //            self.loadingSpinner.dismiss()
    //            self.viewModel.fetchRecentSearch()
    //            self.viewModel.fetchlastSearch()
    //        }
    //    }
    // Automatic Search When Change Text with Some Animations
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.conditionLabel.isHidden = true
//        guard let query = searchBar.text else { return }
//        viewModel.fetchUsers(query: query)
////        UIView.animate(withDuration: 0.0, animations: {
////            self.tableView.alpha = 1.0
////            self.recentSearchTable.alpha = 0.0
////        })
//    }
    // canel and return to man view and return searchBar to tableHeader
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //        viewModel.fetchUsers(query: "a")
//        DispatchQueue.main.async {
//            self.searchController.searchBar.text = nil
//            self.recentSearchTable.isHidden = true
//            self.tableView.isHidden = false
//            self.loadingSpinner.dismiss()
//            self.conditionLabel.isHidden = true
//        }
//    }
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}
