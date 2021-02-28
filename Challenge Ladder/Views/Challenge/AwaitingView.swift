//
//  AwaitingView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 05/12/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

class AwaitingView: UIView{
    
    var presentingVC: ChallengeViewController!
    var challengeRef: DocumentReference!
    var challenge: Challenge!
    var notificationID: String!
    var fromUser: DocumentReference!
    var ladder: Ladder!

    lazy var functions = Functions.functions()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var awaitingResponseLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var acceptChallengeBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.setTitle("Accept Challenge", for: .normal)
        btn.addTarget(self, action:#selector(acceptChallenge), for: .touchUpInside)
        return btn
    }()
    
    var declineChallengeBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.setTitle("Decline Challenge", for: .normal)
        btn.addTarget(self, action:#selector(reject), for: .touchUpInside)
        return btn
    }()
    
    func load(withChallenge: Challenge){
        let db = Firestore.firestore()
        challenge = withChallenge
        challengeRef = db.collection("challenge").document(withChallenge.id)
        
        //Find notification with the challenge reference
        db.collection("notifications").whereField("challengeRef", isEqualTo: challengeRef!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.notificationID = document.documentID
                    let dic = document.data()
                    self.fromUser = dic["fromUser"] as? DocumentReference
                }
                
            }
            self.setupView()
        }
    }
    
    func setupView(){
        self.addSubview(awaitingResponseLabel)
      
        let db = Firestore.firestore()

        awaitingResponseLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(0)
            make.height.equalTo(30)
        }
        
        let myRef = db.collection("users").document(MainUser.shared.userID)
        if fromUser == myRef{
            //I sent the request
            Isenttherequest()
        }
        else{
            //I need to respond to the request
            Ineedtorespond()
        }
       
        
        
    }
    
    func Isenttherequest(){
        awaitingResponseLabel.text = "Awaiting a response from the other user"

    }
    
    func Ineedtorespond(){
        awaitingResponseLabel.text = "Please respond to this challenge"

        self.addSubview(acceptChallengeBtn)
        self.addSubview(declineChallengeBtn)
        
        acceptChallengeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(awaitingResponseLabel.snp.bottom).offset(20)
            make.leading.equalTo(16)
            make.height.equalTo(30)
            make.trailing.equalTo(-16)
        }
        
        declineChallengeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(acceptChallengeBtn.snp.bottom).offset(20)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
    
    @objc func acceptChallenge(){
    
        presentingVC.showLoading()
        
        let data = [
            "fromUser": MainUser.shared.userID!,
            "ladderID": challenge.ladderID!,
            "notificationID": notificationID!,
            "toUser": challenge.userToChallenge.userID!,
            "message": MainUser.shared.username + " has accepted your challenge"
            
        ] as [String : Any]
        
        functions.httpsCallable("acceptChallenge").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.refresh()
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
    
    func decline(){
        //remove notification
        let db = Firestore.firestore()
        
        let reference = db.collection("notifications").document(notificationID)
        reference.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
                
        functions.httpsCallable("deleteChallenge").call(challengeRef.documentID) { (result, error) in
            self.presentingVC.removeLoading()
            let perform: () -> Void = {
                self.presentingVC.navigationController?.popViewControllers(viewsToPop: 1)
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
    
    func deny(){
        presentingVC.showLoading()
            //Add notification
            let db = Firestore.firestore()
        let ladderRef = db.collection("ladders").document(challenge.ladderID)
            db.collection("notifications").document().setData([
                "toUser": fromUser!,
                "message": MainUser.shared.username + " has declined your challenge",
                "type": "message",
                "fromUser": db.collection("users").document(MainUser.shared.userID),
                "ladder": ladderRef,
                "title": "Challenge Declined",
            ]) { [self] err in
                if let err = err {
                    let perform = {}
                    Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self.presentingVC, perform: perform)
                } else {
                    //completed
                }
            }
            decline()
    }
    
    @objc func reject(){
        deny()
    }
    
}
