//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UITableViewController {
     
    var Setting = Titles.darkMode
    var isLoggedIn: Bool {
      if TokenManager.shared.fetchAccessToken() != nil {
        return true
      }
      return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: SignOutCell.self)
        tableView.registerCellNib(cellClass: LanguageCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        title = Titles.settingsViewTitle
        if isLoggedIn {
            //
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = Titles.settingsViewTitle
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
}


extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.row == 0 {
        let cell = tableView.dequeue() as SettingsCell
           cell.DarkModeLabel?.text = Setting
           return cell
       } else if indexPath.row == 1 {
        let cell = tableView.dequeue() as LanguageCell
        cell.languageDelegate = self
        return cell
       } else {
        let cell = tableView.dequeue() as SignOutCell
           cell.delegate = self
           return cell
       }
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
   }
        
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

class header: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userID : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        session.request(GitRouter.gitAuthUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                self.userID.text = "ID:  " + recievedJson["\(AuthenticatedUserInfo.userID)"].stringValue
                let avatar = recievedJson["\(AuthenticatedUserInfo.userAvatar)"].stringValue
                self.userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                self.userAvatar.layer.masksToBounds = false
                self.userAvatar.layer.cornerRadius = self.userAvatar.frame.height/2
                self.userAvatar.clipsToBounds = true
            case .failure(let error):
                print(error)
            }
        
    }
    }
}
