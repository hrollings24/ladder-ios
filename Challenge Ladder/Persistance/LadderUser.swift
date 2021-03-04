//
//  ExternalUser.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 29/08/2020.
//

import FirebaseFirestore

class LadderUser: User{
    
    var position: Int!
    var isMyself: Bool!
    var reference: DocumentReference!
    var canChallenge: Bool!
    
    init(withID: String, atPosition: Int){
        super.init()

        if withID == MainUser.shared.userID {
            isMyself = true
        }
        else{
            isMyself = false
        }
        self.userID = withID
        self.position = atPosition
        let db = Firestore.firestore()
        self.reference = db.collection("users").document(userID)
    }
    
    init(withReference: DocumentReference){
        self.isMyself = false
        self.reference = withReference
    }
    
    func loadUser(completion: @escaping(Bool, Bool)->()) {
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                self.firstName = document.get("firstName") as? String
                self.surname = document.get("surname") as? String
                self.username = document.get("username") as? String
                self.userID = document.documentID
                self.isMyself = document.documentID == MainUser.shared.userID
                completion(true, self.isMyself)
            } else {
                completion(false, false)

                print("An error occured")
            }
        }
    }
}
