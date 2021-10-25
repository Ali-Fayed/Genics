//
//  UsersViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel = UsersViewModel()
    let bag = DisposeBag()
    let tableFooterView = UIView()
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
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
    override func viewWillAppear(_ animated: Bool) {
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
        bindUsersListTableView()
        bindSearchHistoryTableView ()
        bindLastSearchCollectionView()
        subscribeToSearchBar()
        subscribeToLoading()
        dismissButton()
    }
    @objc override func dismissView () {
        viewModel.router?.trigger(.dismiss)
    }
    func subscribeToLoading() {
        viewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "Loading", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: bag)
    }
    func setupConditionLabel(conditionLabel: UILabel) {
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.searchForUsers
        conditionLabel.isHidden = true
    }
    func setupTableView(tableView: UITableView) {
        tableView.registerCellNib(cellClass: UsersTableViewCell.self)
        tableView.tableFooterView = tableFooterView
    }
    func setupSearchHistoryTable(tableView: UITableView) {
        tableView.tableFooterView = tableFooterView
        tableView.isHidden = true
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    func initViewModel () {
        viewModel.fetchDataBaseData()
        if searchController.searchBar.text?.isEmpty == true {
            viewModel.fetchUsers(pageNo: viewModel.pageNo, query: "T")
            setupSearchController(search: searchController, viewController: self)
            navigationItem.title = Titles.usersViewTitle
        } else {
            viewModel.fetchUsers(pageNo: viewModel.pageNo, query: viewModel.query)
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
            title = Titles.resultsViewTitle
        }
    }
}
//MARK: - SearchBar
extension UsersViewController {
    func subscribeToSearchBar () {
        /// animation when click on search bar and push searchBar to navbar headerView
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in
            DispatchQueue.main.async {
                if self?.searchController.isActive == true {
                    self?.usersListTableView.isHidden = true
                    if self?.viewModel.searchHistoryModel.isEmpty == true,
                       self?.viewModel.lastSearchModel.isEmpty == true {
                         self?.conditionLabel.isHidden = false
                     } else {
                         self?.conditionLabel.isHidden = true
                         self?.recentSearchTableView.isHidden = false
                     }
                }
                self?.viewModel.pageNo = 1
                self?.viewModel.isPaginating = false
                self?.viewModel.fetchDataBaseData()
            }
        }).disposed(by: bag)
        /// Save Search Keyword If Click Button Search
        searchController.searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] in
            guard let text = self?.searchController.searchBar.text else { return }
            self?.viewModel.saveSearchWord(text: text)
        }).disposed(by: bag)
        /// canel and return to man view and return searchBar to tableHeader
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] in
                self?.searchController.searchBar.text = nil
                self?.recentSearchTableView.isHidden = true
                self?.usersListTableView.isHidden = false
//                self?.loadingSpinner.dismiss()
                self?.conditionLabel.isHidden = true
                self?.viewModel.fetchDataBaseData()
                self?.viewModel.fetchUsers(pageNo: 1, query: "T")
            }).disposed(by: bag)
        /// Automatic Search When Change Text with Some Animations
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { _ in
            guard let text = self.searchController.searchBar.text else { return }
            if text.isEmpty == false {
                self.viewModel.fetchUsers(pageNo: self.viewModel.pageNo, query: self.viewModel.query(searchText: text))
                self.conditionLabel.isHidden = true
                self.usersListTableView.isHidden = false
                self.recentSearchTableView.isHidden = true
            }
        }).disposed(by: bag)
    }
}
