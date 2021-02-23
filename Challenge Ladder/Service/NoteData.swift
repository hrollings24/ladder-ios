//
//  NoteStruct.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 04/02/2021.
//

import Foundation
import FirebaseFirestore

struct NoteData {
    var message: String
    var type: String
    var fromUser: DocumentReference
    var notification: QueryDocumentSnapshot
    var ladderReference: DocumentReference?
    var challengeReference: DocumentReference?
}
