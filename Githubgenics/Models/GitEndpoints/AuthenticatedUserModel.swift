//
//  AuthenticatedUserModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import Foundation


enum AuthenticatedUserInfo: CustomStringConvertible {
    
    case userName
    case userAvatar
    case userFollowers
    case userFollowing
    case userBio
    case userLoginName
    case userLocation
    case userReposCount
    case userStarttedCount
    case userOrgsCount
    
    var description: String {
        switch self {
        case .userName :
            return "name"
        case .userAvatar:
            return "avatar_url"
        case .userFollowers:
            return "followers"
        case .userFollowing:
            return "following"
        case .userBio:
            return "bio"
        case .userLoginName:
            return "login"
        case .userLocation:
            return "location"
        case .userReposCount:
             return "location"
        case .userStarttedCount:
           return "location"
        case .userOrgsCount:
             return "location"
        }
    }

}
