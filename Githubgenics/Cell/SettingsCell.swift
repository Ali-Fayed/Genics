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
    var defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (defaults.object(forKey: "SwitchState") != nil) {
            DarkModeSwitch.isOn = defaults.bool(forKey: "SwitchState")            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func DarkModeSwitch(_ sender: UISwitch) {
        if DarkModeSwitch.isOn , window!.overrideUserInterfaceStyle == .light {
            window!.overrideUserInterfaceStyle = .dark
            defaults.set(true, forKey: "SwitchState")
            let darkmode = ".dark"
            defaults.set(darkmode, forKey: "Dark")

        } else {
            window!.overrideUserInterfaceStyle = .light
            defaults.set(false, forKey: "SwitchState")
            let darkmode = ".light"
            defaults.set(darkmode, forKey: "Dark")
         
            
        }
        
    }
    
}
