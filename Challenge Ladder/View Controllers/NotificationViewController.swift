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
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "notecell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureRefreshControl()
        getNotifications()
        

    }
    
    
    func getNotifications(){
        
       

        let db = Firestore.firestore()
        let docRef = Firestore.firestore().collection("users").document(MainUser.shared.userID)
        db.collection("notifications").whereField("toUser", isEqualTo: docRef).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.data.removeAll()
                if querySnapshot!.documents.isEmpty{
                    self.setupNoView()
                    self.tableView.isHidden = true
                    self.tableView.reloadData()
                }else{
                    for document in querySnapshot!.documents {
                        if self.noView != nil{
                            self.noView.removeFromSuperview()
                        }
                        let noteData2 = document.data()
                        let noteToAdd = NoteData(message: noteData2["message"] as! String, type: noteData2["type"] as! String, fromUser: noteData2["fromUser"] as! DocumentReference, notification: document, ladderReference: noteData2["ladder"] as? DocumentReference, challengeReference: noteData2["challengeRef"] as? DocumentReference)
                        self.data.append(noteToAdd)
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()

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
                print("Error getting documents: \(err)")
            } else {
                self.data.removeAll()
                if querySnapshot!.documents.isEmpty{
                    // Dismiss the refresh control.
                    DispatchQueue.main.async {
                       self.tableView.refreshControl?.endRefreshing()
                    }
                    self.setupNoView()
                    self.tableView.isHidden = true
                    self.tableView.reloadData()
                }else{
                    for document in querySnapshot!.documents {
                        if self.noView != nil{
                            self.noView.removeFromSuperview()
                        }
                        let noteData2 = document.data()
                        let noteToAdd = NoteData(message: noteData2["message"] as! String, type: noteData2["type"] as! String, fromUser: noteData2["fromUser"] as! DocumentReference, notification: document, ladderReference: noteData2["ladder"] as? DocumentReference, challengeReference: noteData2["challengeRef"] as? DocumentReference)
                        self.data.append(noteToAdd)
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    // Dismiss the refresh control.
                    DispatchQueue.main.async {
                       self.tableView.refreshControl?.endRefreshing()
                    }

                }
            }
        }
        
       
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

        cell.presentingVC = self
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("cell tapped")
        
    }
}

