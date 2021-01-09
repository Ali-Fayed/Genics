//
//
//
//import Alamofire
//import Foundation
//import UIKit
//
class APICaller: UsersView {
//
//    var UsersSt : [UsersStruct] = []
//    var isPaginating = false
//
//    func Fetch(pagination: Bool = false, complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {
//
//        if pagination {
//            isPaginating = true
//        }
//        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
//
//            AF.request("https://api.github.com/users?since=\(Int.random(in: 1 ... 9000))", method: .get).responseJSON { (response) in
//                do {
//                    let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
//                    self.UsersSt = users
//                    self.SkeletonViewLoader()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.dismiss(animated: false, completion: nil)
//                    }
//                } catch {
//                    let error = error
//                    print("Users Parse Error")
//                    print(error.localizedDescription)
//                }
//            }
//
//            complete(.success( pagination ? self.UsersSt : self.UsersSt ))
//            if pagination {
//                self.isPaginating = false
//            }
//        }
//    }
//
}
