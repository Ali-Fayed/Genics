//
//  LastSearch+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 24/01/2021.
//
//

import Foundation
import CoreData


extension LastSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSearch> {
        return NSFetchRequest<LastSearch>(entityName: K.lastSearchEntity)
    }
    
    @NSManaged public var userName: String?
    @NSManaged public var userAvatar: String?
    @NSManaged public var userURL: String?

}
