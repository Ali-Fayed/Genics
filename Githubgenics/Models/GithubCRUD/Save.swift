//
//  save.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import UIKit


class Save: Fetch {
    
    func user(login: String , avatar_url: String , html_url: String) {
        let DataParameters = UsersDataBase(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        DataParameters.html_url = html_url
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func lastSearch(login: String , avatar_url: String , html_url: String) {
        let DataParameters = LastSearch(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        DataParameters.html_url = html_url
        do {
            try context.save()
        } catch {

        }
    }
    
    func repository(name: String , desc: String , language: String , stars: String? , url : String , fulName: String) {
        let DataParameters = SavedRepositories(context: context)
        DataParameters.name = name
        DataParameters.descriptin = desc
        DataParameters.language = language
//        DataParameters.stars = stars! as! NSDecimalNumber
        DataParameters.url = url
        DataParameters.fullName = fulName
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func searchKeywords(keyword: String) {
            let historyData = SearchHistory(context: self.context)
            historyData.keyword = keyword
            do {
                try context.save()
            }
            catch {}
          }
    
}
