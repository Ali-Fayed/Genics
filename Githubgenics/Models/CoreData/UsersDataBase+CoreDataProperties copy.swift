//
//  UsersDataBase+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 22/01/2021.
//
//

import Foundation
import CoreData


extension UsersDataBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersDataBase> {
        return NSFetchRequest<UsersDataBase>(entityName: "SavedUsers")
    }

    @NSManaged public var login: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var html_url: String?

}
