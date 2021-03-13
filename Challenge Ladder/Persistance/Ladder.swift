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
    var initialising: Bool!
    
    init(ref: DocumentReference, completion: @escaping(Result<Ladder, LadderError>)->()) {
        ref.addSnapshotListener { (document, error) in
            if error != nil{
                completion(.failure(.couldnotretrive))
            }
            if let document = document {
                if document.exists{
                    guard let dic = document.data() else {
                        completion(.failure(.nodata))
                        return
                    }
                    self.id = document.documentID
                    let n = dic["name"] as? String
                    self.name = n?.capitalized
                    guard let perAsString = dic["permission"] as? String else {
                        completion(.failure(.corrupt))
                        return
                    }
                    self.permission = LadderPermission(rawValue: perAsString)
                    
                    guard let jump2 = dic["jump"] as? Int else {
                        completion(.failure(.corrupt))
                        return
                    }
                    self.jump = jump2
                        
                        
                    guard let positions2 = dic["positions"] as? [String] else {
                            completion(.failure(.corrupt))
                        return
                    }
                    self.positions = positions2

                                
                                
                    guard let adminsIDs2 = dic["admins"] as? [String] else {
                        completion(.failure(.corrupt))
                        return
                    }
                    self.adminIDs = adminsIDs2
                                    
                                    
                    guard let requests2 = dic["requests"] as? [String] else {
                        completion(.failure(.corrupt))
                        return
                    }
                    self.requests = requests2

                                    
                    if self.initialising == nil{
                        self.initialising = true
                    }
                    else if self.initialising{
                        self.initialising = false
                    }
                    
                    Firestore.firestore().collection("challenge").whereField("ladder", isEqualTo: self.id!).addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.challengesIHaveWithOtherUserIds.removeAll()
                            self.getUser1 { (completed) in
                                self.getUser2 { (completed2) in
                                    if completed && completed2{
                                        if self.updateScene != nil{
                                            self.updateScene.refreshupdate()
                                        }
                                        if self.updateSettings != nil{
                                            self.updateSettings.refreshText()
                                        }
                                        completion(.success(self))
                                    }
                                    else{
                                        completion(.failure(.challengeerror))
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    completion(.failure(.couldnotretrive))
                }
            }
            else{
                completion(.failure(.couldnotbeunwrapped))
            }
        }
    }
    
    func getUser1(completion: @escaping(Bool)->()) {
        let db = Firestore.firestore()
        db.collection("challenge").whereField("ladder", isEqualTo: self.id!).whereField("user1", isEqualTo: MainUser.shared.userID!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(false)
            } else {
                guard let querySnapshot = querySnapshot else {
                    completion(false)
                    return
                }
                for document in querySnapshot.documents {
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
                completion(false)
            } else {
                guard let querySnapshot = querySnapshot else {
                    completion(false)
                    return
                }
                for document in querySnapshot.documents {
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
    
    func updateName(to: String){
        name = to
        let db = Firestore.firestore()
        let docRef = db.collection("ladders").document(id)
        docRef.updateData(["name" : to])
    }
    
}
