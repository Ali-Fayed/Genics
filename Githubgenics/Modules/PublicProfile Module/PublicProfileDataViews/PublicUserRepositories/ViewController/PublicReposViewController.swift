//
//  UsersRepositoryViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import SafariServices
import JGProgressHUD

class PublicReposViewController: ViewSetups {
    
    @IBOutlet weak var tableView: UITableView!
    var starButton = [Int : Bool]()
    lazy var viewModel: PublicReposViewModel  = {
       return PublicReposViewModel ()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel ()
    }
    
    func initView() {
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        renderStarState ()
        conditionLabel.text = Titles.searchForRepos
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func initViewModel() {
        viewModel.renderClickedUserPublicRepositories (tableView: tableView, view: view, loadingSpinner: loadingSpinner, conditionLabel: conditionLabel)
    }
    
    // frame and layout
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
            
    // load button state UD
    func renderStarState () {
        if let checks = UserDefaults.standard.value(forKey: viewModel.passedUser!.userName) as? NSData {
            do {
                try starButton = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(checks as Data) as! [Int : Bool]
            } catch {
                //
            }
        }
    }
    
    // save button state in UD
    func saveStarState () {
        do {
            try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: viewModel.passedUser!.userName)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
}

