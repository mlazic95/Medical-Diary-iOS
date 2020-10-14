//
//  UserDataSource.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-13.
//

import Foundation

class UserDataSource {
    
    static let shared = UserDataSource()
    var user: User?
    private init (){}
    
    func fetchUser(completion: @escaping (APIError?) -> Void) {
        Api.shared.getUser() { (error, user) in
            if let user = user {
                self.user = user
            }
            completion(error)
        }
    }
    
    func getUser() -> User? {
        return self.user
    }
}
