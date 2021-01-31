//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import Alamofire
import Kingfisher

class UsersListViewController: UITableViewController {
    
    var users : [Users] = []
    var moreUsers : [Users] = []
    var isPaginating = false
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBAction func refreshTable(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        //        fetchFirstPage ()
    }
    
    override func viewDidLoad() {
        signOutButton.title = "Signout".localized()
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = signOutButton
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        UsersRouter().listUsers { (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.shimmerLoadingView()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        tableView.resignFirstResponder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.title = "Github Users".localized()
        
    }
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WelcomeScreen.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            UserDefaults.standard.removeObject(forKey: "email")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            SignOutError()
        }
    }
    
    
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    
    
    
    func SignOutError () {
        let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
