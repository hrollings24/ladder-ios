//
//  ViewAdminsInLadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/01/2021.
//

import Foundation
import UIKit
import FirebaseFirestore

class ViewAdminsInLadderViewController: DisplayFindViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Admins"
        
        setupView()
        
    }
    
    func setupView(){
        
        //if ladder has no admins
        if ladder.adminIDs.isEmpty{
            //should be error
            
        }
        else{
            var loadedUserCount = 0
            showLoading()
            data.removeAll()
            for position in ladder.adminIDs{
                //position is the userID
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(position)
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        let firstName = document.get("firstName") as! String
                        let surname = document.get("surname") as! String
                        let name = firstName + " " + surname
                        self.data.append(UserCellData(findingForType: .admin, name: name, cellFunction: .removeAdmin, username: document.get("username") as! String, user: userRef, userID: document.documentID, ladder: self.ladder))
                        loadedUserCount += 1
                        if loadedUserCount == self.ladder.adminIDs.count{
                            self.removeLoading()
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                        }
                    }
                }
            }
        }
    }
  
}

