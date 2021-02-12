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
        return NSFetchRequest<SavedRepositories>(entityName: Entities.repositoryEntity)
    }
    @NSManaged public var repoName: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var repoStars: Float
    @NSManaged public var repoUserFullName: String?
    @NSManaged public var repoProgrammingLanguage: String?
    @NSManaged public var repoURL: String?
    @NSManaged public var isLiked: Bool
}
