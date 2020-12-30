//
//  DetailCellTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//

import UIKit

class DetailCellTableViewCell: UITableViewCell {

    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.init(cgColor: #colorLiteral(red: 0.2355628014, green: 0.2136559784, blue: 0.2124236524, alpha: 1))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
