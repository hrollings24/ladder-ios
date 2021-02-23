//
//  RequestCellData.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 17/02/2021.
//

import FirebaseFirestore

struct RequestCellData{
    var name: String
    var username: String
    var user: DocumentReference
    var userID: String
    var ladder: Ladder
}
