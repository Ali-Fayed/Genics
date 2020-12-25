//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

//JSON Data

struct UsersStruct: Decodable {
    let login: String
    let id: Int
    let html_url: String
    let avatar_url: String
    let url: String
    let repos_url: String
}

struct APIReposData: Decodable {
    let name: String
    let description:String

}
