//
//  Challenge.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 03/09/2020.
//

import FirebaseFirestore
import FirebaseFunctions

class Challenge{
    
    var userToChallenge: LadderUser!
    var id: String!
    var status: String!
    var ladderID: String!
    var winner: String!
    var ladderName: String!
    var winnerselectedby: String!
    
    lazy var functions = Functions.functions()
    
    init(ref: DocumentReference, completion: @escaping(Challenge, ChallengeStatus)->()) {
        
        ref.getDocument { (document, error) in
        if let document = document {
                if document.exists{
                    let dic = document.data()
                    let db = Firestore.firestore()
                    self.id = document.documentID
                    let user1 = dic!["user1"] as? String
                    let user2 = dic!["user2"] as? String
                    self.ladderID = dic!["ladder"] as? String
                    self.status = dic!["status"] as? String
                    self.winner = dic!["winner"] as? String
                    self.ladderName = dic!["ladderName"] as? String
                    self.winnerselectedby = dic!["winnerselectedby"] as? String

                    if user1 == MainUser.shared.userID{
                        self.userToChallenge = LadderUser(withReference: db.collection("users").document(user2!))
                        self.userToChallenge.loadUser { (completed, isMe) in
                            if completed{
                                completion(self, .success)

                            }
                            else{
                                completion(self, .errorRecievingUsers)

                            }
                        }
                    }
                    else{
                        self.userToChallenge = LadderUser(withReference: db.collection("users").document(user1!))
                        self.userToChallenge.loadUser { (completed, isMe) in
                            if completed{
                                completion(self, .success)

                            }
                            else{
                                completion(self, .errorRecievingUsers)

                            }
                        }
                    }
                }
                else {
                    completion(self, .noDocument)
                }
            }
        }
    }
        
       
    

    
    func update(completion: @escaping(Bool)->()) {
        let db = Firestore.firestore()
        let docRef = db.collection("challenge").document(id)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    let dic = document.data()
                    let db = Firestore.firestore()
                    self.id = document.documentID
                    let user1 = dic!["user1"] as? String
                    let user2 = dic!["user2"] as? String
                    self.ladderID = dic!["ladder"] as? String
                    self.status = dic!["status"] as? String
                    self.winner = dic!["winner"] as? String
                    self.ladderName = dic!["ladderName"] as? String
                    self.winnerselectedby = dic!["winnerselectedby"] as? String

                    if user1 == MainUser.shared.userID{
                        self.userToChallenge = LadderUser(withReference: db.collection("users").document(user2!))
                        self.userToChallenge.loadUser { (completed, isMe) in
                            completion(true)
                        }
                    }
                    else{
                        self.userToChallenge = LadderUser(withReference: db.collection("users").document(user1!))
                        self.userToChallenge.loadUser { (completed, isMe) in
                            completion(true)
                        }
                    }
                }
                else{
                    completion(false)
                }
            }
        }
    }
    
    func delete(){
        
        functions.httpsCallable("deleteChallenge").call(id) { (result, error) in
               if let error = error{
                   print("An error occurred while calling the function: \(error)" )
               }
           }
    }
    
    
    func confirmWinner(winner: String, loser: String){
        
        let db = Firestore.firestore()
        let ladderRef = db.collection("ladders").document(ladderID)
        ladderRef.getDocument { document, error in
            if let document = document {
                if document.exists{
                    let dic = document.data()

                    var positions = dic!["positions"] as! [String]
                    
                    let winnerPos = positions.firstIndex(of: winner)!
                    let loserPos = positions.firstIndex(of: loser)!
                    
                    if winnerPos > loserPos{
                        positions.remove(at: winnerPos)
                        positions.remove(at: loserPos)
                        positions.insert(winner, at: loserPos)
                        positions.insert(loser, at: loserPos+1)
                        ladderRef.updateData(["positions" : positions])
                    }
                }
            }
        }
    }
    
    func reject(){
        winner = ""
        winnerselectedby = ""
        
        let db = Firestore.firestore()
        let ladderRef = db.collection("challenge").document(id)
        ladderRef.updateData(["winner" : ""])
        ladderRef.updateData(["winnerselectedby" : ""])
    }
    
    
}
