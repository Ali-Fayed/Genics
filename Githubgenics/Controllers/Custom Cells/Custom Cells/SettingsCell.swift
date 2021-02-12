//
//  SettingsCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/12/2020.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var DarkModeSwitch: UISwitch!
    @IBOutlet weak var DarkModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myswitchBoolValue : Bool = UserDefaults.standard.bool(forKey: "mySwitch")
        if myswitchBoolValue == true {
            print("true")
        }
        else {
            print("false")
        }
    }
    
    @IBAction func DarkModeSwitch(_ sender: UISwitch) {
        var myswitctBool : Bool = false
        if DarkModeSwitch.isOn == true {
            window?.overrideUserInterfaceStyle = .dark
            myswitctBool = true
        }
        else {
            window?.overrideUserInterfaceStyle = .light
            myswitctBool = false
        }
        UserDefaults.standard.set(myswitctBool, forKey: "mySwitch")
    }
}
