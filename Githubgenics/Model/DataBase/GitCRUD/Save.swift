//
//  Save.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import UIKit

class Save: Fetch {
    
    func user(userName: String , userAvatar: String , userURL: String) {
        let items = UsersDataBase(context: context)
        items.userName = userName
        items.userAvatar = userAvatar
        items.userURL = userURL
        do {
            try context.save()
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func lastSearch(userName: String , userAvatar: String , userURL: String) {
        let items = LastSearch(context: context)
        items.userName = userName
        items.userAvatar = userAvatar
        items.userURL = userURL
        do {
            try context.save()
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func repository(repoName: String , repoDescription: String , repoProgrammingLanguage: String , repoStars: String? , repoURL : String , repoUserFullName: String , isLiked: Bool) {
        let items = SavedRepositories(context: context)
        items.repoName = repoName
        items.repoDescription = repoDescription
        items.repoProgrammingLanguage = repoProgrammingLanguage
        //        DataParameters.stars = stars! as! NSDecimalNumber
        items.repoURL = repoURL
        items.repoUserFullName = repoUserFullName
        items.isLiked = isLiked
        do {
            try context.save()
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func searchKeywords(keyword: String) {
        let items = SearchHistory(context: self.context)
        items.keyword = keyword
        do {
            try context.save()
        }
        catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
}
