//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
     
    var Setting = ["Dark Mode"]
    
    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings".localized()

    }
    
    // MARK: - Tableview DataSource

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.DarkModeLabel?.text = Setting[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
