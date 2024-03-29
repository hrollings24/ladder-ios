//
//  LadderCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 29/08/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions
import LetterAvatarKit

class LadderCell: UITableViewCell{
    
    lazy var functions = Functions.functions()
    
    var ladder: Ladder!
    var userID: String!
    var presentingVC: LadderViewController!
    let noteType = "challenge"
    var positions: [Int]!
    
    var data: ladderData? {
        didSet {
            guard let data = data else { return }
            self.nameLabel.text = data.name
            self.userID = data.userID
            self.usernameLabel.text = data.username
            self.positionLabel.text = "Position In Ladder: " + data.position
            self.profilePicture.image = data.picture
            self.profilePicture.layer.masksToBounds = false
            self.profilePicture.layer.borderColor = UIColor.black.cgColor
            self.profilePicture.layer.cornerRadius = 40
            self.profilePicture.clipsToBounds = true
            
            if let _ = ladder.challengesIHaveWithOtherUserIds[data.userID] {
                challengeBtn.setTitle("View Challenge", for: .normal)
                challengeBtn.isEnabled = true
                challengeBtn.addTarget(self, action:#selector(viewChallenge), for: .touchUpInside)
            }
            
            else if positions.contains(Int(data.position)!) {
                challengeBtn.setTitle("Challenge player", for: .normal)
                challengeBtn.isEnabled = true
                challengeBtn.addTarget(self, action:#selector(startChallenge), for: .touchUpInside)

            }
            else if userID == MainUser.shared.userID{
                challengeBtn.setTitle("Withdraw from ladder", for: .normal)
                challengeBtn.isEnabled = true
                challengeBtn.addTarget(self, action:#selector(withdraw), for: .touchUpInside)
            }
            else{
                challengeBtn.setTitle("You cannot challenge this player", for: .normal)
                challengeBtn.isEnabled = false

            }
            
          
        }
    }
    
    
    var nameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()
    
    var usernameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()
    
    var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var positionLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var challengeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("You cannot challenge this player", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.isUserInteractionEnabled = true
        btn.titleLabel?.textAlignment = .left
        btn.titleLabel?.numberOfLines = 2
        btn.setTitleColor(.white, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        return btn
    }()

    
    let container: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.addSubview(container)
        
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
          
        container.addSubview(nameLabel)
        container.addSubview(positionLabel)
        container.addSubview(usernameLabel)
        container.addSubview(challengeBtn)
        container.addSubview(profilePicture)


        self.isUserInteractionEnabled = true
        container.isUserInteractionEnabled = true
        
        
        nameLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 56).isActive = true

        profilePicture.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel.snp.leading).offset(10)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(profilePicture.snp.trailing).offset(10)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.equalTo(profilePicture.snp.trailing).offset(10)
        }
        
        challengeBtn.snp.makeConstraints { make in
            make.top.equalTo(positionLabel.snp.bottom).offset(5)
            make.leading.equalTo(positionLabel.snp.leading)
        }
        
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
           UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
               self.contentView.layoutIfNeeded()
           })
       }
    
    @objc func startChallenge(){
       
        presentingVC.showLoading()
        let msg = MainUser.shared.username + " has challenged you in " + ladder.name
        let challengeData = ["ladderID": ladder.id!, "fromUser": MainUser.shared.userID!, "message": msg, "toUser": userID!, "ladderName": ladder.name!]  as [String : Any]


        functions.httpsCallable("createChallenge").call(challengeData) { (result, error) in
            self.presentingVC.removeLoading()
            let perform = {}

                if let error = error{
                   print("An error occurred while calling the function: \(error)" )
               }
               else{
                let resultData = result!.data as! NSDictionary
                Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self.presentingVC, perform: perform)
               }
           }
    }
    
 
    
    @objc func withdraw(){
        
        let alertController = UIAlertController(title: "Withdraw", message: "Are you sure you want to withdraw from this ladder?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) {
                UIAlertAction in
            
                
                self.finalWithdraw()
            
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) {
                UIAlertAction in
            
        }
        
        alertController.addAction(noAction)

        alertController.addAction(okAction)
        presentingVC.present(alertController, animated: true, completion: nil)
        
    }
    
    func finalWithdraw(){
        presentingVC.showLoading()
        
        
        let withdrawData = ["ladderID": ladder.id!, "userID": userID!, "isAdmin": ladder.adminIDs.contains(userID)] as [String : Any]
        let perform = {
            self.presentingVC.dismiss(animated: true, completion: nil)
        }

        functions.httpsCallable("withdrawUserFromLadder").call(withdrawData) { (result, error) in
            self.presentingVC.removeLoading()

               if let error = error{
                   print("An error occurred while calling the function: \(error)" )
               }
               else{
                Alert(withTitle: "Success", withDescription: "You were successfully removed from the ladder", fromVC: self.presentingVC, perform: perform)
               }
           }
    }
    
    @objc func viewChallenge(){
        print("view challenge")
        presentingVC.showLoading()
        
        let db = Firestore.firestore()
        if ladder.challengesIHaveWithOtherUserIds[data!.userID] == nil{
            Alert(withTitle: "Error", withDescription: "The challenge could not be found", fromVC: self.presentingVC, perform: {})
            presentingVC.removeLoading()
        }
        else{
            let challengeRef = db.collection("challenge").document(ladder.challengesIHaveWithOtherUserIds[data!.userID]!)
            Challenge(ref: challengeRef, completion: { (theChallenge, challengeStatus) in
               switch challengeStatus{
               case .documentEmpty:
                Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self.presentingVC, perform: {})
               case .success:
                    self.presentingVC.removeLoading()
                    let newVC = ChallengeViewController()
                    newVC.challenge = theChallenge
                    newVC.previousVC = self.presentingVC
                    self.presentingVC.navigationController?.pushViewController(newVC, animated: true)
               case .noDocument:
                Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self.presentingVC, perform: {})

               case .errorRecievingUsers:
                Alert(withTitle: "Error", withDescription: "Error retriving challenge participents", fromVC: self.presentingVC, perform: {})

               }
                self.presentingVC.removeLoading()

               
              
                
            })
        }
        
        
        
    }

    
    
}
