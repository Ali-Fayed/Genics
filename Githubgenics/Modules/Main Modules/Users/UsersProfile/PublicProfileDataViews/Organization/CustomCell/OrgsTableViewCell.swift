//
//  OrgsTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit

class OrgsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellData (with model : Orgs) {
        textLabel?.text = model.orgName
        detailTextLabel?.text = model.orgDescription
    }

}
