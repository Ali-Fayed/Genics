//
//  Alerts.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/01/2021.
//

import UIKit

class Alerts  {

    static let shared = Alerts()
    
    
    let errorFromCoreData: UIAlertController = {
      let alert = UIAlertController(title: "", message: "An error occurred please try again".localized(), preferredStyle: .alert)
      alert.view.tintColor = UIColor.black
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
        alert.addAction(action)
      return alert
    }()
    
    func showErrorAlert() {
      let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(Alerts.shared.errorFromCoreData, animated: true, completion: nil)
    }
    
    //MARK:- Paging Error
    
    let userPaginationErrorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "Next page error please wait and try again or open VPN".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
          let action = UIAlertAction(title: "Ok", style: .default) { (action) in
          }
        action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
          alert.addAction(action)
        return alert
    }()
    
    func showPaginationErrorAlert() {
      let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(Alerts.shared.userPaginationErrorAlert, animated: true, completion: nil)
    }
    
    //MARK:- User Repos Error
    
    let userRepositoryFetchErrorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "Repositories limit reached please wait and try again or open VPN".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
          let action = UIAlertAction(title: "Ok", style: .default) { (action) in
          }
        action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
          alert.addAction(action)
        return alert
    }()
    
    func showUserRepositoryFetchErrorAlert() {
      let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(Alerts.shared.userRepositoryFetchErrorAlert, animated: true, completion: nil)
    }
    
    //MARK:- search user error
    
    let searchUsersErrorAlert: UIAlertController = {
      let alert = UIAlertController(title: "", message: "Searching limit reached please wait 60 sec and try again or open VPN".localized(), preferredStyle: .alert)
      alert.view.tintColor = UIColor.black
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
        alert.addAction(action)
      return alert
    }()
    
     func showSearchUsersErrorAlert() {
      let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(Alerts.shared.searchUsersErrorAlert, animated: true, completion: nil)
    }
    
  
   //MARK:- search repo error
    
    let searchRepositoriesErrorAlert: UIAlertController = {
      let alert = UIAlertController(title: "", message: "Repositories searching limit reached wait 60 sec and try again or open VPN".localized(), preferredStyle: .alert)
      alert.view.tintColor = UIColor.black
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
        alert.addAction(action)
      return alert
    }()
    
    func showSearchRepositoriesErrorAlert() {
      let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(Alerts.shared.searchRepositoriesErrorAlert, animated: true, completion: nil)
    }
    

}
