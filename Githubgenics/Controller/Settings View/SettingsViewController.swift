//
//  SettingsView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
     
    var Setting = "Dark Mode"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SignOutCell.nib(), forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings".localized()

    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.settingsCell, for: indexPath) as! SettingsCell
            cell.DarkModeLabel?.text = Setting
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SignOutCell
            cell.delegate = self

            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


