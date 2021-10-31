//
//  FindUserCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 17/02/2021.
//

import UIKit
import FirebaseFunctions

class UserCell: UITableViewCell{
    
    lazy var functions = Functions.functions()
    var presentingVC: LoadingViewController!
    
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
    
    var button: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.isUserInteractionEnabled = true
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    var data: UserCellData? {
        didSet {
            guard let data = data else { return }
            self.nameLabel.text = data.name
            self.usernameLabel.text = data.username
            switch data.cellFunction{
            case .inviteAdmin:
                button.setTitle("add", for: .normal)
                button.addTarget(self, action:#selector(inviteAdmin), for: .touchUpInside)
                break
            case .inviteUser:
                button.setTitle("add", for: .normal)
                button.addTarget(self, action:#selector(inviteUser), for: .touchUpInside)
                break
            case .removeAdmin:
                button.setTitle("remove", for: .normal)
                button.addTarget(self, action:#selector(removeAdmin), for: .touchUpInside)
                break
            case .removeUser:
                button.setTitle("remove", for: .normal)
                button.addTarget(self, action:#selector(removeUser), for: .touchUpInside)
                break
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(button)
        self.addSubview(blankView)

        self.isUserInteractionEnabled = true

        nameLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(usernameLabel.snp.top)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(blankView.snp.top)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalTo(0)
            make.bottom.equalTo(blankView.snp.top)
        }
        
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(usernameLabel.snp.top)
        }
        
        usernameLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(blankView.snp.top)
        }
        
        button.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalTo(0)
            make.bottom.equalTo(blankView.snp.top)
        }
        
        blankView.snp.remakeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func inviteUser(){
        presentingVC.showLoading()
        
        let dataToSend = [
            "toUserID": data!.user.documentID,
            "message": MainUser.shared.username + " has invited you to join " + data!.ladder.name,
            "ladderID": data!.ladder.id!,
            "type": "invite",
            "title": "Invitation Recieved",
            "fromUser": MainUser.shared.userID!,
            "username": usernameLabel.text!
        ] as [String : Any]
        
        functions.httpsCallable("inviteUser").call(dataToSend) { (result, error) in
            self.presentingVC.removeLoading()
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: {})
            }
            else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: {})
            }
            
        }
    }
    
    @objc func inviteAdmin(){
        presentingVC.showLoading()
        
        let dataToSend = [
            "toUserID": data!.user.documentID,
            "message": MainUser.shared.username + " has invited you to be an admin of " + data!.ladder.name,
            "ladderID": data!.ladder.id!,
            "type": "admin",
            "title": "Admin Request Recieved",
            "fromUser": MainUser.shared.userID!,
            "username": usernameLabel.text!
        ] as [String : Any]
        
        functions.httpsCallable("addAdmin").call(dataToSend) { (result, error) in
            self.presentingVC.removeLoading()
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self.presentingVC, perform: {})
            }
            else{
                let resultData = result!.data as! NSDictionary
                print(resultData)

                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: {})
            }
            
        }
    }
    
    @objc func removeUser(){
        let perform = {
            
            //Remove the user from the ladder
            //Send a notification to the user that they have been removed by as admin
            let data = [
                "userIDToDelete": self.data!.userID,
                "ladderID": self.data!.ladder.id!,
                "message": "You have been removed from " + self.data!.ladder.name + " by an admin",
                "type": "message",
                "fromUser": MainUser.shared.userID!,
                "isAdmin": self.data!.ladder.adminIDs.contains(self.data!.userID)
            ] as [String : Any]
            
            self.presentingVC.showLoading()
            self.functions.httpsCallable("deleteUserFromAdmin").call(data) { (result, error) in
                self.presentingVC.removeLoading()
                let perform: () -> Void = {
                    self.presentingVC.navigationController?.popToViewController(ofClass: LadderViewController.self, animated: true)
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
        
        CancelAlert(isDestructive: false, withTitle: "Confirm Removal", withDescription: "Are you sure you want to remove " + data!.username + " from the ladder?", fromVC: presentingVC, perform: perform)

    }
    
    @objc func removeAdmin(){
        let perform = {
            
            //Remove the admin from the ladder
            //Check that the admin is not themselves.
            if self.data!.userID == MainUser.shared.userID{
                if self.data!.ladder.adminIDs.count == 1{
                    //SELECT NEW ADMIN FROM USER LIST
                    if self.data!.ladder.positions.count == 0{
                        //delete ladder
                        let data = ["ladderID": self.data!.ladder.id]

                        self.presentingVC.showLoading()

                        self.functions.httpsCallable("deleteLadder").call(data) { (result, error) in
                            self.presentingVC.removeLoading()
                            if let error = error{
                               print("An error occurred while calling the function: \(error)" )
                            }
                            else{
                                let resultData = result!.data as! NSDictionary
                                let perform = {}

                                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
                            }
                        }
                        
                    }
                    else{
                        //select new admin
                        let perform = {
                            
                            let vc = FindUserViewController()
                            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                            vc.ladder = self.data!.ladder
                            vc.findingFor = .admin
                            self.presentingVC.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        CancelAlert(isDestructive: false, withTitle: "New Admin Required", withDescription: "You must select a new admin for this ladder as there are players in the ladder.", fromVC: self.presentingVC, perform: perform)
                                                
                    }
                }
                else{
                    //can remove the admin
                    let perform: () -> Void = {
                        self.presentingVC.navigationController?.popToViewController(ofClass: LadderViewController.self, animated: true)
                    }
                    self.data!.ladder.removeAdmin(admin: self.data!.userID)
                    Alert(withTitle: "Success", withDescription: "Admin removed", fromVC: self.presentingVC, perform: perform)
                }
            }
            //Admin is not themselves
            //Remove the admin!
            else{
                let perform: () -> Void = {
                    self.presentingVC.navigationController?.popToViewController(ofClass: LadderViewController.self, animated: true)
                }
                self.data!.ladder.removeAdmin(admin: self.data!.userID)
                Alert(withTitle: "Success", withDescription: "Admin removed", fromVC: self.presentingVC, perform: perform)
            }
            
        }
        
        CancelAlert(isDestructive: true, withTitle: "Confirm Removal", withDescription: "Are you sure you want to remove " + data!.username + " as an admin?", fromVC: presentingVC, perform: perform)

    }
    
}
