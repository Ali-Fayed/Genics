//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by Ali Fayed on 23/01/2021.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: Entities.searchHistoryEntity)
    }

    @NSManaged public var keyword: String?

}
