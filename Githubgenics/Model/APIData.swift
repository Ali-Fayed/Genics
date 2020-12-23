//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

//JSON Data

struct APIUsersData: Decodable, Identifiable {
    let login: String
    let id: Int
    let html_url: String
//    let bio: String
    
}

struct APIReposData: Decodable {
    let name: String
    let id: Int 
    
}

