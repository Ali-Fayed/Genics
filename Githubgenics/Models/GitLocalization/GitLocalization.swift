//
//  GitLocalization.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/01/2021.
//

import Foundation

struct Titles {
    static let usersViewTitle        = "Users".localized()
    static let DetailViewTitle       = "Profile".localized()
    static let bookmarksViewTitle    = "Bookmarks".localized()
    static let repositoriesViewTitle = "Repositories".localized()
    static let commitsViewTitle      = "Commits".localized()
    static let settingsViewTitle     = "Settings".localized()
    static let searchPlacholder      = " Search...".localized()
    static let searchHistory         = "RECENT SEARCHES".localized()
    static let signInButtonTitle     = "Sign in with GitHub".localized()
    static let signinWith            = "Sign in with GitHub".localized()
    static let signinWithout         = "Try without Github!".localized()
    static let byContinue            = "by continue any way you will face API usage limit issues!".localized()
    static let Loginin               = "Login Options".localized()
    static let makeSure              = "make sure you read the README file and fetch your client ID & client secret to Login with Github and avoid 404 web error or Try without!!".localized()
    static let bySign                = "By sigining in you accept Github".localized()
    static let continuee             = "Continue!".localized()
    static let terms                 = "Terms of use".localized()
    static let privacyPolicy         = "Privacy policy.".localized()
    static let and                   = "and".localized()
    static let darkMode              = "Dark Mode".localized()
    static let logOut                = "Log Out".localized()
    static let more                  = "More".localized()
    static let bookmark              = "Bookmark".localized()
    static let url                   = "URL".localized()
    static let cancel                = "Cancel".localized()
    static let removeAll             = "Remove All".localized()
    static let deleteAllRecords      = "Delete All Records!".localized()
    static let langauge              = "Change to English".localized()
    static let Starred              = "Starred".localized()
    static let Organizations              = "Organizations".localized()
    static let profileViewTitle                  = "Profile".localized()
    static let noOrgs                   = "There aren't any orgs.".localized()
    static let noRepos                 = "There aren't any repos.".localized()
    static let noStartted                  = "There aren't any Startted.".localized()
    static let searchForUsers           = "Search For users.".localized()
    static let searchForRepos           = "Search For repos.".localized()
    static let searchForSaved           = "Search For saved".localized()
    static let noBookmarks              = "No Bookmarks".localized()
    static let noTokenLabel             = "Not Signed In"
}

struct Messages {
    static let internetError = "Please check your connection".localized()
    static let requestError = "Ooops something wrong happened Error Code 404!".localized()
}

extension String {
    func localized () -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self
        )
    }
}
