//
//  Calls.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit
import Firebase


extension UsersListViewController {
    
    func fetchUsersList () {
        UsersRouter().listUsers { [weak self] result in
            switch result {
            case .success(let users):
                self!.users.append(contentsOf: users)
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                    self!.shimmerLoadingView()
                }
            case .failure(_):
             break
            }
        }
    }
    
    func fetchMoreFromUsersList () {
        guard !isPaginating else {
            return
        }
         MainFetchFunctions(pagination: true, since: Int.random(in: 40 ... 5000 ), page: 10 ) { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            switch result {
            case .success(let moreUsers):
                self?.users.append(contentsOf: moreUsers)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                AlertsModel.shared.showPaginationErrorAlert()
            break
            }
        }
    }
    
    func refreshList () {
        UsersRouter().listUsers { [weak self] result in
            switch result {
            case .success(let users):
                self!.users.append(contentsOf: users)
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            case .failure(_):
             break
            }
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
    
    
    func performSignOut () {
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
}
