//
//  ConstantsModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit

struct Cells {
    static let usersCell = "UsersCell"
    static let repositoriesCell = "repositoryCell"
    static let userRepositoryCell = "userRepositoryCell"
    static let commitCell = "CommitCell"
    static let settingsCell = "SettingsCell"
    static let searchHistoryCell = "searchHistoryCell"
    static let lastSearchCell = "lastSearchCell"
    static let signOutCell = "SignOutCell"
    static let UsersNib = "UsersCell"
    static let siignOutNib = "SignOutCell"
    static let repositoryNib = "ReposCell"
    static func signOutNib() -> UINib { return UINib(nibName: Cells.siignOutNib, bundle: nil) }
    static func reposNib() -> UINib { return UINib(nibName: Cells.repositoryNib, bundle: nil) }
    static func usersNib() -> UINib { return UINib(nibName: Cells.UsersNib, bundle: nil) }
}
