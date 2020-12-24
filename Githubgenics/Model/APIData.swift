//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

//JSON Data

struct APIUsersData: Decodable {
    let login: String
    let id: Int
    let html_url: String
    let avatar_url: String
    let url: String
    let repos_url: String
}

struct APIReposData: Decodable {
    let name: String
//    let id: Int
//    let description: String
}

struct UserAPI: Decodable {
    let login: String
//    let company: String
//    let bio: String
//    let name: String
//    let following: Int
//    let followers: Int
//    let public_repos: Int
}

