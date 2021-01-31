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

    @NSManaged public var name: NSObject?
    @NSManaged public var descriptin: NSObject?
    @NSManaged public var url: NSObject?
    @NSManaged public var stars: NSObject?
    @NSManaged public var language: NSObject?

}
