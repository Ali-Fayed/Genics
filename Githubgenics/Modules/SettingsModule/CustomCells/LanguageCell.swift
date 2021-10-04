//
//  LanguageCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/02/2021.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var language: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        language.text = Titles.langauge
    }
    
}
