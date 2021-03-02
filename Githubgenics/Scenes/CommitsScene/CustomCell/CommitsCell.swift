//
//  CommitsCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/03/2021.
//

import UIKit

class CommitsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func CellData(with model: Commit) {
        textLabel?.text = model.authorName
        detailTextLabel?.text = model.message
    }
    
}
