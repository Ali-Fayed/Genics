////
////  CoreData.swift
////  Githubgenics
////
////  Created by Ali Fayed on 25/01/2021.
////
//
//import UIKit
//import CoreData
//
//class CoreData {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var searchHistory = [SearchHistory]()
//    var lastSearch = [LastSearch]()
//    static let shared = CoreData()
//    
//
//    func createNewSearchHistoryItem (keyword: String) {
//        let historyData = SearchHistory(context: context)
//        historyData.keyword = keyword
//        do {
//            try context.save()
//            fetchSearchHistory ()
//        } catch {}
//    }
//    
//    func fetchSearchHistory () {
//        do {
//            searchHistory = try context.fetch(SearchHistory.fetchRequest())
//            lastSearch = try context.fetch(LastSearch.fetchRequest())
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.collectionView.reloadData()
//            }
//        } catch {
//            
//        }
//    }
//    
//    func saveSearchKeywords (keyword: String) {
//        let historyData = SearchHistory(context: context)
//        historyData.keyword = keyword
//        do {
//            try context.save()
//            fetchAllData ()
//        } catch {}
//    }
//    
//    func deleteSearchHistoryItem (item: SearchHistory) {
//        context.delete(item)
//        do {
//            try context.save()
//            fetchSearchHistory()
//
//        } catch {
//            
//        }
//    }
//}
