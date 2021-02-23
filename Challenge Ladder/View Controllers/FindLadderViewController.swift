//
//  FindLadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 04/11/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

class FindLadderViewController: FindViewController {

    var data = [LadderData]()
    lazy var functions = Functions.functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Find Ladders"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectLadderCell.self, forCellReuseIdentifier: "selectladdercell")

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Tell the keyboard where to go on next / go button.
        if textField == searchField {
            // do stuff
            returnLadder(ladderToSearchFor: searchField.text!)
        }

        return true
    }
    
    func returnLadder(ladderToSearchFor: String){
        showLoading()
        
        let db = Firestore.firestore()
        db.collection("ladders").whereField("permission", in: ["Open", "Public, with Requests"]).whereField("name", isEqualTo: ladderToSearchFor.lowercased())
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
                    self.setup(withLadders: documentArray)
                }
            }
        }
    }
    
    
    func setup(withLadders: [QueryDocumentSnapshot]){
        
        var loadedLadderCount = 0
        data.removeAll()
        for ladder in withLadders{
            Ladder(ref: ladder.reference, completion: { [self] (completed) in
                data.append(LadderData(nameofladder: completed.name!, ladderitself: completed))
                loadedLadderCount += 1
                if loadedLadderCount == withLadders.count{
                    removeLoading()
                    tableView.reloadData()
                    tableView.isHidden = false
                    nothingFoundLabel.isHidden = true
                }
            })
        }
    }
}

extension FindLadderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectladdercell", for: indexPath) as! SelectLadderCell
        
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       
        //What happens when the user clicks on a cell
        let perform = {
            let data = ["ladderID": self.data[indexPath.row].ladderitself.id, "userID": MainUser.shared.userID]
            self.showLoading()

            self.functions.httpsCallable("requestToJoinALadder").call(data) { (result, error) in
                self.removeLoading()

                if let error = error{
                   print("An error occurred while calling the function: \(error)" )
                }
                else{
                    let resultData = result!.data as! NSDictionary
                    let perform = {}

                    Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self, perform: perform)
                }
            }
        }


        CancelAlert(withTitle: "Join Ladder", withDescription: "Confirm you want to join this ladder", fromVC: self, perform: perform)
    
    }
}
