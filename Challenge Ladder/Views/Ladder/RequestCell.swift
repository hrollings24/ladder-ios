//
//  RequestCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 17/02/2021.
//

import UIKit
import FirebaseFunctions

class RequestCell: UITableViewCell{
    
    lazy var functions = Functions.functions()
    var presentingVC: ViewRequestsViewController!
    
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
    
    var rejectButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.isUserInteractionEnabled = true
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitle("Reject", for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    var acceptButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.isUserInteractionEnabled = true
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitle("Accept", for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    var data: RequestCellData? {
        didSet {
            guard let data = data else { return }
            self.nameLabel.text = data.name
            self.usernameLabel.text = data.username
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(acceptButton)
        self.addSubview(rejectButton)

        self.addSubview(blankView)
        rejectButton.addTarget(self, action:#selector(rejectInvoked), for: .touchUpInside)
        acceptButton.addTarget(self, action:#selector(acceptInvoked), for: .touchUpInside)
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
        
        acceptButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalTo(0)
            make.bottom.equalTo(rejectButton.snp.top)
            make.height.equalTo(nameLabel.snp.height)
        }
        
        rejectButton.snp.makeConstraints { (make) in
            make.top.equalTo(acceptButton.snp.bottom)
            make.trailing.equalTo(0)
            make.bottom.equalTo(blankView.snp.top)
            make.height.equalTo(usernameLabel.snp.height)
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
        
        acceptButton.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalTo(0)
            make.bottom.equalTo(rejectButton.snp.top)
            make.height.equalTo(nameLabel.snp.height)
        }
        
        rejectButton.snp.remakeConstraints { (make) in
            make.top.equalTo(acceptButton.snp.bottom)
            make.trailing.equalTo(0)
            make.bottom.equalTo(blankView.snp.top)
            make.height.equalTo(usernameLabel.snp.height)
        }
        
        blankView.snp.remakeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func acceptInvoked(){
        //data = [toUserID: String, ladderID: String, fromUser: String, message: String]
        presentingVC.showLoading()
        let msg = "Your request to join " + data!.ladder.name + " has been accepted"

        let data = [
            "toUserID": data!.userID,
            "ladderID": data!.ladder.id!,
            "fromUser": MainUser.shared.userID!,
            "message": msg
        ] as [String : Any]
        
        functions.httpsCallable("acceptRequest").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.refreshViews()
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
    
  
    
    
    @objc func rejectInvoked(){
        //data = [requestUserID: String, ladderID: String, message: String, fromUser: String]
        presentingVC.showLoading()
        let msg = "Your request to join " + data!.ladder.name + " has been rejected"

        let data = [
            "requestUserID": data!.userID,
            "ladderID": data!.ladder.id!,
            "fromUser": MainUser.shared.userID!,
            "message": msg
        ] as [String : Any]
        
        functions.httpsCallable("rejectRequest").call(data) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {
                self.presentingVC.refreshViews()
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
}
