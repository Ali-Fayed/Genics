////
////  hh.swift
////  Githubgenics
////
////  Created by Ali Fayed on 09/01/2021.
////
//
//import Foundation
//import UIKit
//import Alamofire
//
//class OK: UsersView {
//    
//    struct API {
//        
// 
//    }
//    private var Users : [UsersStruct] = []
//    var isPaginating = false
//    var UsersAPIStruct = [UsersStruct]()
//
//
//     func FetchUsers (completed: @escaping () -> ()) {
//        AF.request("https://api.github.com/users", method: .get).responseJSON { (response) in
//            do {
//                if let safedata = response.data {
//                    let repos = try JSONDecoder().decode([UsersStruct].self, from: safedata)
//                    UsersAPIStruct = repos
////                        self.tableView.reloadData()
////                        self.SkeletonViewLoader ()
//                    DispatchQueue.main.async {
//                        completed()
//                    }
//                }
//            }
//            catch {
//                let error = error
//                print(error.localizedDescription)
////                self.ErroLoadingRepos ()
////                    self.Error()
//            }
//        }
//    }
//   
////
////    private var Users : [UsersStruct] = []
////    var isPaginating = false
////
////     func Fetch(pagination: Bool = false, since : Int , page : Int , complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {
////
////        if pagination {
////            isPaginating = true
////        }
////        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
////         let url = "https://api.github.com/users?since=\(since)&per_page=\(page)"
////
////         AF.request(url , method: .get).responseJSON { (response) in
////                do {
////                    let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
////                    self.Users = users
////                 self.tableView.reloadData()
////                 self.dismiss(animated: false, completion: nil)
////
////                 print("Main Fetch")
////                } catch {
////                    let error = error
////                    print(error.localizedDescription)
////                }
////            }
////            complete(.success( pagination ? self.Users : self.Users ))
////
////            if pagination {
////                self.isPaginating = false
////            }
////        }
////    }
////
////
////    func FetchUsers () {
////        AF.request("https://api.github.com/users", method: .get).responseJSON { (response) in
////            do {
////                if let safedata = response.data {
////                    let repos = try JSONDecoder().decode([UsersStruct].self, from: safedata)
////                    self.UsersAPIStruct = repos
////                    self.tableView.reloadData()
////                    self.SkeletonViewLoader ()
////                }
////            }
////            catch {
////                let error = error
////                print(error.localizedDescription)
//////                self.ErroLoadingRepos ()
////                self.Error()
////            }
////        }
////    }
////
////    func FetchMoreUsers () {
////        guard !isPaginating else {
////            return
////        }
////        Fetch(pagination: true, since: Int.random(in: 40 ... 5000 ), page: 10 ) { [weak self] result in
////            DispatchQueue.main.async {
////                self?.tableView.tableFooterView = nil
////            }
////            switch result {
////            case .success(let UsersAPIStruct):
////                self?.UsersAPIStruct.append(contentsOf: UsersAPIStruct)
////                DispatchQueue.main.async {
////                    self?.tableView.reloadData()
////                }
////
////            case .failure(_):
////                self!.Error()
////            break
////            }
////        }
////    }
//}
