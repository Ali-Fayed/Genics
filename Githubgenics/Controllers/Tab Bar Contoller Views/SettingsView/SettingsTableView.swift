//
//  SettingsTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 12/02/2021.
//

import UIKit

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: Cells.settingsCell, for: indexPath) as! SettingsCell
           cell.DarkModeLabel?.text = Setting
           return cell
       } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: Cells.signOutCell, for: indexPath) as! SignOutCell
           cell.delegate = self

           return cell
       }
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
   }
   
}
