//
//  SavedRepository+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 06/02/2021.
//
//

import Foundation
import CoreData


extension SavedRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRepository> {
        return NSFetchRequest<SavedRepository>(entityName: "SavedRepository")
    }

    @NSManaged public var repoName: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var repoStars: NSDecimalNumber?
    @NSManaged public var repoUserFullName: String?
    @NSManaged public var repoProgrammingLanguage: String?
    @NSManaged public var repoURL: String?

}
