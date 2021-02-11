//
//  Localization Model.swift
//  Githubgenics
//
//  Created by Ali Fayed on 26/01/2021.
//

import Foundation


extension String {
    func localized () -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self
        )
    }
}
