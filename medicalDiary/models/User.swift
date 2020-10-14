//
//  User.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-13.
//

import Foundation

struct User: Codable {
    let _id: String
    let created: String
    let fullName: String?
    let email: String?
}
