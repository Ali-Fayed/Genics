//
//  GitCellDelegates.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit

protocol DetailViewCellDelegate: AnyObject {
    func didTapButton(cell:ReposTableViewCell, didTappedThe button:UIButton?)
}
