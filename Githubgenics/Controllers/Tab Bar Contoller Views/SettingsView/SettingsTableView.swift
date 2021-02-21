//
//  SettingsTableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 12/02/2021.
//

import UIKit

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
