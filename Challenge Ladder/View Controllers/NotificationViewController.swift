//
//  NotificationViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 28/08/2020.
//

import UIKit
import FirebaseFirestore

class NotificationViewController: BaseViewController {
    
    var noView: NoView!
    
    var data = [NoteData]()
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"

        view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "notecell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureRefreshControl()
        
        
        getNotifications()
        
        
        setupNoView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension

    }
    
    
    func getNotifications(){

        let db = Firestore.firestore()
        let docRef = Firestore.firestore().collection("users").document(MainUser.shared.userID)
        db.collection("notifications").whereField("toUser", isEqualTo: docRef).addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self, perform: {})
            } else {
                
                let result = self.setupNotes(withSnapshot: querySnapshot)
                switch result{
                
                case .snapshotcouldnotbeunwrapped, .message, .type, .fromUser:
                    Alert(withTitle: "Error", withDescription: result.rawValue, fromVC: self, perform: {})
                case .success:
                    break
                }
            }
        }
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }

    @objc func handleRefreshControl() {
       // Update your content…

        let db = Firestore.firestore()
        let docRef = Firestore.firestore().collection("users").document(MainUser.shared.userID)
        
        db.collection("notifications").whereField("toUser", isEqualTo: docRef).addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self, perform: {})
            } else {
                
                let result = self.setupNotes(withSnapshot: querySnapshot)
                switch result{
                
                case .snapshotcouldnotbeunwrapped, .message, .type, .fromUser:
                    Alert(withTitle: "Error", withDescription: result.rawValue, fromVC: self, perform: {})
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }
    
    func setupNotes(withSnapshot: QuerySnapshot?) -> NotificationError{
        self.data.removeAll()
        
        guard let querySnapshot = withSnapshot else {
            return NotificationError.snapshotcouldnotbeunwrapped
        }

        if querySnapshot.documents.isEmpty{
            // Dismiss the refresh control.
            DispatchQueue.main.async {
               self.tableView.refreshControl?.endRefreshing()
            }
            self.noView.isHidden = false
            self.tableView.isHidden = true
            self.tableView.reloadData()
        } else{
            for document in querySnapshot.documents {
                self.noView.isHidden = true
                
                let noteData2 = document.data()
                
                guard let message = noteData2["message"] as? String else {
                    return NotificationError.message
                }
                guard let type = noteData2["type"] as? String else {
                    return NotificationError.type
                }
                guard let fromUser = noteData2["fromUser"] as? DocumentReference else {
                    return NotificationError.fromUser
                }
                
                
                let noteToAdd = NoteData(message: message, type: type, fromUser: fromUser, notification: document, ladderReference: noteData2["ladder"] as? DocumentReference, challengeReference: noteData2["challengeRef"] as? DocumentReference)
                self.data.append(noteToAdd)
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        return .success
    }

    func setupNoView(){
        
        let sizeOfNoLadderView = CGRect(x: 0, y: 0, width: self.view.frame.width - 16, height: 70)
        noView = NoView(frame: sizeOfNoLadderView)
        noView.load(withText: "You have no notifications")
        self.view.addSubview(noView)
        noView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(16)
        }
        
    }
  
    

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notecell", for: indexPath) as! NotificationCell
        
        cell.acceptBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.denyBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.contentView.isUserInteractionEnabled = false // <<-- the solution

        cell.presentingVC = self
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
   
}

