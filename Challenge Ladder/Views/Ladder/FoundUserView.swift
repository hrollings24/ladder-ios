//
//  FoundUserView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 23/08/2020.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFunctions

/*
class FoundUserView: UIView{
    
    var user: QueryDocumentSnapshot!
    var ladder: Ladder!
    var presentingVC: FindUserViewController!
    var notificationType: NoteType!
    lazy var functions = Functions.functions()
    
    
    var nameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    
    var usernameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.blue, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoad(withUser: QueryDocumentSnapshot, inLadder: Ladder, forNote: NoteType){
        user = withUser
        ladder = inLadder
        notificationType = forNote
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(addBtn)
        
        if notificationType == .invite{
            addBtn.addTarget(self, action:#selector(addPressed), for: .touchUpInside)
        }
        else{
            addBtn.addTarget(self, action:#selector(addAdmin), for: .touchUpInside)
        }
        
        let data = user.data()
        let firstname = data["firstName"] as! String
        let surname = data["surname"] as! String
        let name = firstname + " " + surname
        nameLabel.text = name
        usernameLabel.text = data["username"] as? String
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.height.equalTo(self.bounds.height / 2)
            make.trailing.equalTo((self.bounds.width / 3 ) * 2)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.bottom.leading.equalToSuperview()
            make.height.equalTo(self.bounds.height / 2)
            make.trailing.equalTo((self.bounds.width / 3 ) * 2)
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.bottom.top.trailing.equalToSuperview()
            make.leading.equalTo((self.bounds.width / 3 ) * 2)
            
        }

    }
    
    @objc func addPressed(){
        presentingVC.showLoading()
        
        let data = [
            "toUserID": user.documentID,
            "message": MainUser.shared.username + " has invited you to join " + ladder.name,
            "ladderID": ladder.id!,
            "type": notificationType.rawValue,
            "title": "Invitation Recieved",
            "fromUser": MainUser.shared.userID!,
            "username": usernameLabel.text!
        ] as [String : Any]
        
        functions.httpsCallable("inviteUser").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: {})
            }
            let resultData = result!.data as! NSDictionary
            Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: {})
        }
    }
    
    @objc func addAdmin(){
        presentingVC.showLoading()
        
        let data = [
            "toUserID": user.documentID,
            "message": MainUser.shared.username + " has invited you to be an admin of " + ladder.name,
            "ladderID": ladder.id!,
            "type": notificationType.rawValue,
            "title": "Admin Request Recieved",
            "fromUser": MainUser.shared.userID!,
            "username": usernameLabel.text!
        ] as [String : Any]
        
        functions.httpsCallable("addAdmin").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: {})
            }
            let resultData = result!.data as! NSDictionary
            print(resultData)

            Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: {})
        }
    }
}

 */
