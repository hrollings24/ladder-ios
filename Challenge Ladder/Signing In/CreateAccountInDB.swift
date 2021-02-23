//
//  CreateAccountInDB.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 18/02/2021.
//

import FirebaseFirestore
import FirebaseFunctions
import FirebaseMessaging

class CreateAccountInDB{
    
    lazy var functions = Functions.functions()
    
    private var username: String!
    private var firstName: String!
    private var surname: String!
    private var userID: String!

    
    init(username: String, firstName: String, surname: String, userID: String) {
        self.username = username
        self.firstName = firstName
        self.surname = surname
        self.userID = userID

    }
    
    public func createUser(completion: @escaping (CreatingAccountStatus)->()){
                
        //Check username doesn't already exist
        let data = [
            "username": username!
        ] as [String : Any]
        
        functions.httpsCallable("checkUsername").call(data) { (result, error) in
            let resultAsBool = result!.data as! Bool
            if !resultAsBool{
                //username is already taken
                completion(.usernameTaken)
            }
            else{
                self.save() { (finished) in
                    completion(finished)
                }
            }
        }
    }
    
    private func save(completion: @escaping (CreatingAccountStatus)->()){
        
        //user initially has no ladders
        let ladders = [DocumentReference]()
        //user initially has no challenges
        let challenges = [DocumentReference]()
    
        let db = Firestore.firestore()
        let fcmArray = [Messaging.messaging().fcmToken!]
                
        db.collection("users").document(userID).setData([
            "firstName": firstName!,
            "surname": surname!,
            "ladders": ladders,
            "username": username.lowercased(),
            "challenges": challenges,
            "fcm": fcmArray
        ]) { err in
            if let err = err {
                //ERROR
                print(err)
                completion(.internalError)
            } else {
                //SUCCESS
                completion(.success)
            }
        }
    }
}


