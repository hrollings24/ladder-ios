//
//  FindUserViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 23/08/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

class FindUserViewController: FindViewController {
    
    var ladder: Ladder!
    
    var data = [UserCellData]()
    lazy var functions = Functions.functions()
    var findingFor: UserCellType!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "usercell")
        tableView.delegate = self
        tableView.dataSource = self
        
        nothingFoundLabel.text = "No users found"
        
        searchField.placeholder = "Search for user"
        self.title = "Find Users"

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Tell the keyboard where to go on next / go button.
        if textField == searchField {
            // do stuff
            returnUserList(usernameToSearchFor: searchField.text!.lowercased())
        }

        return true
    }
    
    func returnUserList(usernameToSearchFor: String){
        showLoading()
        
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: usernameToSearchFor)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var documentArray = [QueryDocumentSnapshot]()
                for document in querySnapshot!.documents {
                    documentArray.append(document)
                }
                if documentArray.isEmpty{
                    self.removeLoading()
                    self.tableView.isHidden = true
                    self.nothingFoundLabel.isHidden = false
                }
                else{
                    self.setup(withUsers: documentArray)
                }
            }
        }
    }
    
    func setup(withUsers: [QueryDocumentSnapshot]){
        
        var loadedUserCount = 0
        data.removeAll()
        for user in withUsers{
            let userData = user.data()
            let firstname = userData["firstName"] as! String
            let surname = userData["surname"] as! String
            let name = firstname + " " + surname
            switch findingFor{
            case .admin:
                data.append(UserCellData(findingForType: findingFor, name: name, cellFunction: .inviteAdmin, username: userData["username"] as! String, user: user.reference, userID: user.documentID, ladder: ladder))
            case .user:
                data.append(UserCellData(findingForType: findingFor, name: name, cellFunction: .inviteUser, username: userData["username"] as! String, user: user.reference, userID: user.documentID, ladder: ladder))
            case .none:
                //error
                break
            }
            loadedUserCount += 1
            if loadedUserCount == withUsers.count{
                removeLoading()
                self.tableView.isHidden = false
                tableView.reloadData()
                self.nothingFoundLabel.isHidden = true
            }
        }
    }
}

extension FindUserViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        cell.button.removeTarget(nil, action: nil, for: .allEvents)
        cell.contentView.isUserInteractionEnabled = false // <<-- the solution
        cell.isUserInteractionEnabled = true

        cell.data = data[indexPath.row]
        cell.presentingVC = self
        cell.button.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nothing happens when user clicks on cell

    }
}
