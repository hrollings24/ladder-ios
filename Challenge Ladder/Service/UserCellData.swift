//
//  Type-Users.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 02/11/2020.
//

import Foundation
import FirebaseFirestore

enum UserCellType: String{
    case user = "user"
    case admin = "admin"
}

enum UserCellFunction{
    case inviteUser
    case removeAdmin
    case inviteAdmin
    case removeUser
}

struct UserCellData{
    var findingForType: UserCellType
    var name: String
    var cellFunction: UserCellFunction
    var username: String
    var user: DocumentReference
    var userID: String
    var ladder: Ladder
}

