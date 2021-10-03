//
//  UsersStartedViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class PublicStarredViewController: CommonViews {
    
    weak var delegate : DetailViewCellDelegate?
    var starButton = [Int : Bool]()
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: PublicStarredViewModel = {
       return PublicStarredViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView ()   {
        title = Titles.starredViewTitle
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        view.addSubview(conditionLabel)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = tableFooterView
        renderStarState ()
        conditionLabel.text = Titles.noStarred
    }
    
    func initViewModel () {
        viewModel.loadStarred (tableView: tableView, view: view, loadingSpinner: loadingSpinner, conditionLabel: conditionLabel)
    }
    
    // frame and layout
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
        
    // load button state UD
    func renderStarState () {
        if let checks = UserDefaults.standard.value(forKey: viewModel.passedUser!.userURL) as? NSData {
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
            try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: starButton, requiringSecureCoding: true), forKey: viewModel.passedUser!.userURL)
            UserDefaults.standard.synchronize()
        } catch {
            //
        }
    }
    
}
