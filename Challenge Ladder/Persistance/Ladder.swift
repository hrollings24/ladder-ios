//
//  Ladder.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 15/08/2020.
//

import Foundation
import FirebaseFirestore
import Firebase

class Ladder{
    
    var positions: [String]!
    var name: String!
    var adminIDs: [String]!
    var jump: Int!
    var id: String!
    var permission: LadderPermission!
    var requests: [String]!
    var challengesIHaveWithOtherUserIds: [String: String] = [:]
    var updateScene: LadderViewController!
    var updateSettings: LadderSettingsViewController!
    
    init(ref: DocumentReference, completion: @escaping(Ladder)->()) {
        ref.addSnapshotListener { (document, error) in
            if let document = document {
                print(document.exists)
                if document.exists{
                    let dic = document.data()
                    self.id = document.documentID
                    let n = dic!["name"] as? String
                    self.name = n?.capitalized
                    let perAsString = dic!["permission"] as? String
                    self.permission = LadderPermission(rawValue: perAsString!)
                    self.jump = dic!["jump"] as? Int
                    self.positions = dic!["positions"] as? [String]
                    self.adminIDs = dic!["admins"] as? [String]
                    self.requests = dic!["requests"] as? [String]
                    
                    Firestore.firestore().collection("challenge").whereField("ladder", isEqualTo: self.id!).addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.challengesIHaveWithOtherUserIds.removeAll()
                            self.getUser1 { (completed) in
                                self.getUser2 { (completed2) in
                                    if self.updateScene != nil{
                                        self.updateScene.refreshupdate()
                                    }
                                    if self.updateSettings != nil{
                                        self.updateSettings.refreshText()
                                    }
                                    completion(self)
                                }
                            }
                        }
                    }
                   
                 
                    
                }
            }
        }
    }
    
    func getUser1(completion: @escaping(Bool)->()) {
        let db = Firestore.firestore()
        db.collection("challenge").whereField("ladder", isEqualTo: self.id!).whereField("user1", isEqualTo: MainUser.shared.userID!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dic = document.data()
                    self.challengesIHaveWithOtherUserIds[(dic["user2"] as? String)!] = document.documentID
                }
                completion(true)
            }
        }
    }
    
    func getUser2(completion: @escaping(Bool)->()) {
        let db = Firestore.firestore()
        db.collection("challenge").whereField("ladder", isEqualTo: self.id!).whereField("user2", isEqualTo: MainUser.shared.userID!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dic = document.data()
                    self.challengesIHaveWithOtherUserIds[(dic["user1"] as? String)!] = document.documentID
                }
                completion(true)
            }
        }
    }
    
    
    
    func updateJump(to: Int){
        jump = to
        let db = Firestore.firestore()
        let docRef = db.collection("ladders").document(id)
        docRef.updateData(["jump" : jump!])
    }
    
    func addNew(admin: String){
        adminIDs.append(admin)
        let db = Firestore.firestore()
        let docRef = db.collection("ladders").document(id)
        docRef.updateData(["admins" : adminIDs!])
    }
    
    func removeAdmin(admin: String){
        if let index = adminIDs.firstIndex(of: admin) {
            adminIDs.remove(at: index)
        }
        let db = Firestore.firestore()
        let docRef = db.collection("ladders").document(id)
        docRef.updateData(["admins" : adminIDs!])
    }
    
}
