//
//  Cell Delegate.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit

protocol DidTapCell : AnyObject {
    func didTapButton(cell:ReposCell, didTappedThe button:UIButton?)
}

protocol DidTapSignOutCell : AnyObject {
    func didTapButton(cell:SignOutCell, didTappedThe button:UIButton?)
}

