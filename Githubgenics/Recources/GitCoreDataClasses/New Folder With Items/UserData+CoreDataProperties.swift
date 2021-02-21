//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 22/12/2020.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var login: String?

}
