//
//  NotificationCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 04/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

class NotificationCell: UITableViewCell{
    
    
    lazy var functions = Functions.functions()

    
   
    
    var presentingVC: NotificationViewController!

    var fromUser: DocumentReference!
    var type: String!
    var isMessage: Bool!
    var notification: QueryDocumentSnapshot!
    var ladderReference: DocumentReference!
    var challengeRef: DocumentReference!
    
    var data: NoteData? {
        didSet {
            guard let data = data else { return }
            self.fromUser = data.fromUser
            self.type = data.type
            self.messageLabel.text = data.message
            self.notification = data.notification
            self.ladderReference = data.ladderReference
            self.challengeRef = data.challengeReference
            
            switch type{
            case "challenge":
                isMessage = false
                acceptBtn.isHidden = false
                denyBtn.isHidden = false
                denyBtn.addTarget(self, action:#selector(deny), for: .touchUpInside)
                acceptBtn.addTarget(self, action:#selector(acceptChallenge), for: .touchUpInside)

                break
            case "invite":
                isMessage = false
                acceptBtn.isHidden = false
                denyBtn.isHidden = false
                denyBtn.addTarget(self, action:#selector(declineInvite), for: .touchUpInside)
                acceptBtn.addTarget(self, action:#selector(acceptInvite), for: .touchUpInside)

                break
            case "admin":
                isMessage = false
                acceptBtn.isHidden = false
                denyBtn.isHidden = false
                denyBtn.addTarget(self, action:#selector(declineAdminInvite), for: .touchUpInside)
                acceptBtn.addTarget(self, action:#selector(acceptAdmin), for: .touchUpInside)

                break
            case "message":
                isMessage = true
                acceptBtn.isHidden = false
                denyBtn.isHidden = true
                acceptBtn.setTitle("OK", for: .normal)
                acceptBtn.addTarget(self, action:#selector(decline), for: .touchUpInside)

            case "request":
                acceptBtn.isHidden = false
                denyBtn.isHidden = true
                isMessage = true
                acceptBtn.setTitle("View Request", for: .normal)
                acceptBtn.addTarget(self, action:#selector(goToRequest), for: .touchUpInside)

                break
            default:
                //error
                isMessage = false
                break
            }
            
        }
    }
    
    var blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var messageLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = false
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        return textLabel
    }()
    
    var acceptBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Accept", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    var denyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Decline", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(acceptBtn)
        self.addSubview(denyBtn)
        self.addSubview(messageLabel)
        self.addSubview(blankView)
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(acceptBtn.snp.top)
        }
        
        acceptBtn.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.bottom.equalTo(blankView.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalTo(-self.frame.width / 2)
        }

        denyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
            make.leading.equalTo(acceptBtn.snp.trailing)
            make.bottom.equalTo(blankView.snp.top)
        }
     
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(acceptBtn.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        messageLabel.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        if !isMessage{
            acceptBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.bottom.equalTo(blankView.snp.top)
                make.leading.equalToSuperview()
                make.trailing.equalTo(-self.frame.width / 2)
            }

            denyBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.trailing.equalToSuperview()
                make.leading.equalTo(acceptBtn.snp.trailing)
                make.bottom.equalTo(blankView.snp.top)
            }
        }
        else{
            acceptBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.bottom.equalTo(blankView.snp.top)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
        
        blankView.snp.remakeConstraints { (make) in
            make.top.equalTo(acceptBtn.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    
    //BUTTON ACTIONS
    
    
    @objc func declineAdminInvite(){
        //data = [oldNoteID: String, oldnoteToUser: String, oldNoteFromUser: String, ladderRef: String, username: String]

        let data = [
            "oldNoteID": notification.documentID,
            "oldnoteToUser": MainUser.shared.userID!,
            "oldNoteFromUser": fromUser.documentID,
            "ladderRef": ladderReference.documentID,
            "username": MainUser.shared.username!
        ] as [String : Any]
        
        presentingVC.showLoading()
        functions.httpsCallable("rejectAdminInvite").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.getNotifications()
            }
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: perform)
            }
            else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
            }
        }
    }
    
    @objc func declineInvite(){
        let data = [
            "oldNoteID": notification.documentID,
            "oldnoteToUser": MainUser.shared.userID!,
            "oldNoteFromUser": fromUser.documentID,
            "ladderRef": ladderReference.documentID,
            "username": MainUser.shared.username!
        ] as [String : Any]
        
        presentingVC.showLoading()
        functions.httpsCallable("rejectNormalInvite").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.getNotifications()
            }
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: perform)
            }
            else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
            }
        }
    }
    
    
    @objc func goToRequest(){
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
               return
           }
        
        if let navController = rootViewController as? UINavigationController {
                
            let pushVC = ViewRequestsViewController()
            pushVC.setupView(withReference: ladderReference)
            navController.pushViewController(pushVC, animated: true)

        }
        
    }
    
    @objc func acceptInvite(){
        //add user to the bottom of the ladder
        ladderReference.updateData([
            "positions": FieldValue.arrayUnion([MainUser.shared.userID!])
        ])
        if !MainUser.shared.ladders.contains(ladderReference){
            MainUser.shared.ladders.append(ladderReference)
            MainUser.shared.push()
        }
        let perform = {}
        Alert(withTitle: "Added", withDescription: "You have been added to the ladder", fromVC: presentingVC, perform: perform)
        decline()
    }
    
    @objc func acceptAdmin(){
        presentingVC.showLoading()
        
        //add user to the bottom of the ladder
        let data = [
            "fromUserID": MainUser.shared.userID!,
            "ladderID": ladderReference.documentID,
            "notificationID": notification.documentID,
            "username": MainUser.shared.username!,
            "toUserID": fromUser.documentID
        ] as [String : Any]
        
        functions.httpsCallable("acceptAdminInvite").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {}
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: perform)
            }
            else{
                Alert(withTitle: "Success", withDescription: result!.data as! String, fromVC: self.presentingVC, perform: perform)
            }
        }
    }
    
    @objc func acceptChallenge(){
    
        presentingVC.showLoading()
        
        //add user to the bottom of the ladder
        let data = [
            "fromUser": MainUser.shared.userID!,
            "ladderID": ladderReference.documentID,
            "notificationID": notification.documentID,
            "toUser": fromUser.documentID,
            "message": MainUser.shared.username + " has accepted your challenge"
            
        ] as [String : Any]
        
        functions.httpsCallable("acceptChallenge").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.decline()
            }
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: perform)
            }
            else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
            }
        }
            
        
        
    }
    
    
    @objc func declineChallenge(){
        //remove notification
        let db = Firestore.firestore()
        
        let reference = db.collection("notifications").document(notification.documentID)
        reference.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        
        functions.httpsCallable("deleteChallenge").call(challengeRef.documentID) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.getNotifications()
            }
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: perform)
            }
            else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
            }
        }
        
        
    }
    
    @objc func deny(){
        presentingVC.showLoading()
            //Add notification
            let db = Firestore.firestore()
            db.collection("notifications").document().setData([
                "toUser": fromUser!,
                "message": MainUser.shared.username + " has declined your challenge",
                "type": "message",
                "fromUser": db.collection("users").document(MainUser.shared.userID),
                "ladder": ladderReference!,
                "title": "Challenge Declined",
            ]) { [self] err in
                if let err = err {
                    let perform = {}
                    Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self.presentingVC, perform: perform)
                } else {
                    //completed
                }
            }
            declineChallenge()
        }
    
    
    @objc func decline(){
        //remove notification
        let db = Firestore.firestore()
        
        let reference = db.collection("notifications").document(notification.documentID)
        reference.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.presentingVC.getNotifications()
    }
        
        

}
    
