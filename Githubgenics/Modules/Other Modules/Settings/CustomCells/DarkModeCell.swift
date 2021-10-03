//
//  SettingsCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class DarkModeCell: UITableViewCell {
    
    @IBOutlet weak var darkModeSwitch: UISwitch?
    @IBOutlet weak var darkModeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myswitchBoolValue : Bool = UserDefaults.standard.bool(forKey: "mySwitch")
        if myswitchBoolValue == true {
            darkModeSwitch?.isOn = true
            window?.overrideUserInterfaceStyle = .dark
        } else {
            darkModeSwitch?.isOn = false
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        var myswitctBool : Bool = false
        if darkModeSwitch?.isOn == true {
            window?.overrideUserInterfaceStyle = .dark
            myswitctBool = true
        } else {
            window?.overrideUserInterfaceStyle = .light
            myswitctBool = false
        }
        UserDefaults.standard.set(myswitctBool, forKey: "mySwitch")
    }
}
