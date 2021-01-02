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
        DarkModeSwitch.isOn = false
        overrideUserInterfaceStyle = .light

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func DarkModeSwitch(_ sender: UISwitch) {
        if DarkModeSwitch.isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
    }
    
}
