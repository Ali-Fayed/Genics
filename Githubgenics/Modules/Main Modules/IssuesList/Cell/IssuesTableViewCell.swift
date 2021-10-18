//
//  IssuesTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit

class IssuesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellViewModel(with model: Issue) {
        textLabel?.text = model.issueTitle
        detailTextLabel?.text = model.issueState
    }

}
