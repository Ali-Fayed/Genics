//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//


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
    let size: Int
    let html_url: String
    let created_at: String
    let updated_at: String
    let stargazers_count: Int
    let watchers_count: Int
    let language: String
    let forks_count: Int
    let default_branch: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case svn_url
        case size
        case html_url
        case created_at
        case updated_at
        case stargazers_count
        case watchers_count
        case language
        case forks_count
        case default_branch
    }
}

