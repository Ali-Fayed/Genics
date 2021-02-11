//
//  SavedRepositories+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 25/01/2021.
//
//

import Foundation
import CoreData


extension SavedRepositories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRepositories> {
        return NSFetchRequest<SavedRepositories>(entityName: K.repositoryEntity)
    }
    @NSManaged public var repoName: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var repoStars: NSDecimalNumber?
    @NSManaged public var repoUserFullName: String?
    @NSManaged public var repoProgrammingLanguage: String?
    @NSManaged public var repoURL: String?
    @NSManaged public var isLiked: Bool

//    @NSManaged public var name: String?
//    @NSManaged public var descriptin: String?
//    @NSManaged public var url: String?
//    @NSManaged public var stars: NSDecimalNumber?
//    @NSManaged public var language: String?
//    @NSManaged public var fullName: String?
    

    

    

}
