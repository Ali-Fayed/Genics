//
//  Fetch.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import CoreData


class DataBaseManger {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func Fetch<T: NSManagedObject>(returnType: T.Type , completion: @escaping ([T]) -> Void) {
        do {
            guard let result = try context.fetch(returnType.fetchRequest()) as? [T] else {
                return
            }
            completion(result)
        } catch {
            //
        }
    }
    

    func Delete<T: NSManagedObject>(returnType: T.Type, Delete: T) {
        context.delete(Delete.self)
        do {
            try context.save()
        } catch {
            //
        }
    }
    
}
