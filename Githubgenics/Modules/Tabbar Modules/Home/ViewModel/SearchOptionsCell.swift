//
//  SearchOptionsCellViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 07/04/2021.
//

import UIKit

class SearchOptionsCell: UITableViewCell {
    
    func cellViewModel(with model: ProfileTableData, with searchText: String) {
        textLabel?.text = model.cellHeader + " with " + "'" + searchText + "'"
        imageView?.image = UIImage(named: model.image)
    }
}
