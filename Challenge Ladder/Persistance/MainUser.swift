//
//  Data.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/08/2020.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class MainUser: User{
    
    var ladders: [DocumentReference]!
    var challenges: [DocumentReference]!
    
    static var shared = MainUser()
    
    var db = Firestore.firestore()
    
    func getUser(withID: String, completion: @escaping(RetriveDocumentStatus)->() ){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(withID)
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                completion(RetriveDocumentStatus.noDocument)
                return
            }
            guard let data = document.data() else {
                completion(RetriveDocumentStatus.documentEmpty)
                return
            }
            self.firstName = document.get("firstName") as? String
            self.surname = document.get("surname") as? String
            self.username = document.get("username") as? String
            self.pictureURL = document.get("picture") as? String
            self.userID = withID
            self.ladders.removeAll()
            let laddersArray = data["ladders"] as? NSArray
            for lad in laddersArray!{
                self.ladders.append(lad as! DocumentReference)
            }
            let challengesArray = data["challenges"] as? NSArray
            self.challenges.removeAll()
            for challenge in challengesArray!{
                self.challenges.append(challenge as! DocumentReference)
            }
            
            if let profilePictureURL = MainUser.shared.pictureURL {
                let url = URL(string: profilePictureURL)
                URLSession.shared.dataTask(with: url!) { data, response, error in
                    if (error == nil){
                        DispatchQueue.main.async {
                            self.picture = UIImage(data: data!)
                            completion(RetriveDocumentStatus.success)
                        }
                    }
                }.resume()
            }
            else{
                var initials = ""
                if let letter = MainUser.shared.firstName.first {
                    initials += (String(letter))
                }
                if let letter = MainUser.shared.surname.first {
                    initials += (String(letter))
                }
                self.picture = UIImage.makeLetterAvatar(withUsername: initials.uppercased())

                completion(RetriveDocumentStatus.success)

            }
            
            
                
        }
    }
    
    override init(){
        super.init()
        self.ladders = [DocumentReference]()
        self.challenges = [DocumentReference]()
    }
    
    func push(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        docRef.updateData(["ladders" : ladders!])
        docRef.updateData(["challenges" : challenges!])

    }
    
    func changeUsername(to: String){
        let db = Firestore.firestore()
        username = to
        let docRef = db.collection("users").document(userID)
        docRef.updateData(["username" : to])
    }
    
    
}
