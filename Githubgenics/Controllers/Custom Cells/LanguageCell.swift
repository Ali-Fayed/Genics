//
//  LanguageCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/02/2021.
//

import UIKit

class LanguageCell: UITableViewCell {

    weak var languageDelegate : DidChangeLanguage?
    @IBOutlet weak var language: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        language.setTitle(Titles.langauge, for: .normal)
        
    }
    
    @IBAction func didChangeLang(_ sender: Any) {
        languageDelegate?.didChangeLang(cell: self, didTappedThe: sender as? UIButton)

    }
}

extension SettingsViewController : DidChangeLanguage {
    func didChangeLang(cell: LanguageCell, didTappedThe button: UIButton?) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}
