//
//  HomeViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

import UIKit
import SwiftyJSON
import SafariServices

class HomeViewController: CommonViews {
    //MARK: - @IBOutlets
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var searchOptionsTableView: UITableView!
    //MARK: - Props
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistoryTableView.reloadData()
        reloadTableViewData(tableView: homeTableView, tableView1: searchHistoryTableView, tableView2: searchOptionsTableView)
    }
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - View Methods
    func initView () {
        title = Titles.homeViewTitle
        tabBarItem.title = Titles.homeViewTitle
        conditionLabel.text = Titles.searchGithub
        setupSearchController(search: searchController)
        homeTableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        searchController.searchBar.delegate = self
        searchHistoryTableView.isHidden = true
        searchOptionsTableView.isHidden = true
        conditionLabel.isHidden = true
    }
    func initViewModel  () {
        viewModel.initHomeTableCellData()
        viewModel.initSearchOptionsTableCellData()
        viewModel.initLocalDataBaseCellData()
    }
}
//MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { [self] in
            self.searchHistoryTableView.reloadData()
            if searchController.searchBar.text?.isEmpty == true {
                homeTableView.isHidden = true
                searchOptionsTableView.isHidden = true
                reloadTableViewData(tableView: self.searchHistoryTableView, tableView1: self.searchOptionsTableView, tableView2: nil)

                switch viewModel.searchHistory.isEmpty {
                case true:
                    searchHistoryTableView.isHidden = true
                    conditionLabel.isHidden = false
                default:
                    searchHistoryTableView.isHidden = false
                    conditionLabel.isHidden = true
                }
            } else {
                homeTableView.isHidden = true
                searchHistoryTableView.isHidden = true
                searchOptionsTableView.isHidden = false
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DataBaseManger().fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.viewModel.searchHistory = result
        }
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.isHidden = false
            self?.searchHistoryTableView.isHidden = true
            self?.searchOptionsTableView.isHidden = true
            self?.conditionLabel.isHidden = true
            self?.searchHistoryTableView.reloadData()
            self?.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self?.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchOptionsTableView.reloadData()
            self?.conditionLabel.isHidden = true
            
            switch searchText.isEmpty {
            case true:
                self?.searchOptionsTableView.isHidden = true
                self?.searchHistoryTableView.isHidden = false
            default:
                self?.searchOptionsTableView.isHidden = false
                self?.searchHistoryTableView.isHidden = true
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.saveSearchWord(text: searchText)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}
