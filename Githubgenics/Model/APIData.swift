//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

//JSON Data
class customData {
    let User = [UsersStruct]()
    var ButtonState = false
    
}
struct UsersStruct: Decodable {
    let login: String
    let id: Int
    let html_url: String
    let avatar_url: String
    let url: String
    let repos_url: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case html_url
        case avatar_url
        case url
        case repos_url
    }
}

struct ReposStruct: Codable {
    let name: String
    let description:String
    let svn_url: String
}

