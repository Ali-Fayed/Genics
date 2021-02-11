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
        return NSFetchRequest<UsersDataBase>(entityName: K.usersEntity)
    }

    @NSManaged public var userName: String?
    @NSManaged public var userAvatar: String?
    @NSManaged public var userURL: String?

}
