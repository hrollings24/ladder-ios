//
//  ChallengeViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 03/09/2020.
//

import UIKit
import FirebaseFirestore

class ChallengeViewController: LoadingViewController {

    var challenge: Challenge!
    var ladder: Ladder!
    var previousVC: UIViewController!
    
    
    
    var userToChallengeName: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var challengeInLadderName: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var statusName: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var playedLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Completed your challenge? Pick the winner here"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = -1
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var player1Btn: UserButton = {
        let btn = UserButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action:#selector(player1BtnPressed), for: .touchUpInside)
        return btn
    }()
    
    var player2Btn: UserButton = {
        let btn = UserButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action:#selector(player2BtnPressed), for: .touchUpInside)
        return btn
    }()
    
    var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.setTitle("Confirm", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action:#selector(finalise), for: .touchUpInside)
        return btn
    }()
    
    var rejectBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.setTitle("Reject", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action:#selector(reject), for: .touchUpInside)
        return btn
    }()
    
    func refresh(){
        showLoading()
        challenge.update { completed in
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.removeLoading()
            self.viewDidLoad()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Challenge"
        
        self.view.backgroundColor = .background
        
        userToChallengeName.text = challenge.userToChallenge.firstName + " " + challenge.userToChallenge.surname
        challengeInLadderName.text = challenge.ladderName
        statusName.text = "Status: " + challenge.status
        
        self.view.addSubview(userToChallengeName)
        self.view.addSubview(challengeInLadderName)
        self.view.addSubview(statusName)
        
        userToChallengeName.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(16)
        }
        
        challengeInLadderName.snp.makeConstraints { (make) in
            make.top.equalTo(userToChallengeName.snp.bottom).offset(10)
            make.leading.equalTo(16)
        }
        
        statusName.snp.makeConstraints { (make) in
            make.top.equalTo(challengeInLadderName.snp.bottom).offset(20)
            make.leading.equalTo(16)
        }
        
        
        
        if challenge.status == "Awaiting Response"{
            let awaitView = AwaitingView()
            awaitView.load(withChallenge: challenge)
            self.view.addSubview(awaitView)
            awaitView.presentingVC = self
            awaitView.snp.makeConstraints { (make) in
                make.top.equalTo(statusName.snp.bottom).offset(50)
                make.bottom.equalToSuperview()
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                
            }
        }
        else{
            setupOngoing()
        }
        
        
    }
    
    func setupOngoing(){
        
        playedLabel.removeFromSuperview()
        confirmBtn.removeFromSuperview()
        rejectBtn.removeFromSuperview()
        player1Btn.removeFromSuperview()
        player2Btn.removeFromSuperview()
        
        self.view.addSubview(playedLabel)

        
        playedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusName.snp.bottom).offset(50)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        if challenge.winner != ""{
            
            if challenge.winnerselectedby == MainUser.shared.userID{
                playedLabel.text = "Awating confirmination from " + challenge.userToChallenge.firstName
            }
            else{
                //get user for winner
                if challenge.winner == challenge.userToChallenge.userID{
                    playedLabel.text = "Confirm that " + challenge.userToChallenge.firstName + " has won the challenge"
                }
                else if challenge.winner == MainUser.shared.userID{
                    playedLabel.text = "Confirm that " + MainUser.shared.firstName + " has won the challenge"
                }
                self.view.addSubview(confirmBtn)
                
                confirmBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(playedLabel.snp.bottom).offset(20)
                    make.leading.equalTo(16)
                    make.trailing.equalTo(-16)
                }
                
                self.view.addSubview(rejectBtn)
                
                rejectBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(confirmBtn.snp.bottom).offset(10)
                    make.leading.equalTo(16)
                    make.trailing.equalTo(-16)
                }
            }
        }
        else{
            playedLabel.text = "Completed your challenge? Pick the winner here"
            player1Btn.add(user: MainUser.shared)
            player2Btn.add(user: challenge.userToChallenge)
            
            self.view.addSubview(player1Btn)
            self.view.addSubview(player2Btn)
            
            player1Btn.snp.makeConstraints { (make) in
                make.top.equalTo(playedLabel.snp.bottom).offset(20)
                make.leading.equalTo(16)
                make.trailing.equalTo(-self.view.bounds.width / 2)
            }
            
            player2Btn.snp.makeConstraints { (make) in
                make.top.equalTo(playedLabel.snp.bottom).offset(20)
                make.leading.equalTo(player1Btn.snp.trailing)
                make.trailing.equalTo(-26)
            }
        }
    }
    

    @objc func player1BtnPressed(){
        confirmWinner(asUser: player1Btn.user)
    }
    
    @objc func player2BtnPressed(){
        confirmWinner(asUser: player2Btn.user)

    }
    
    func confirmWinner(asUser: User){
        // create the alert
        let message = "Confirm that " + asUser.firstName! + " has won the challenge?"
        let perform = {
            let finished = self.challenge.addWinner(userID: asUser.userID)
            if finished == true{
                self.refresh()
            }
        }
        CancelAlert(withTitle: "Confirm", withDescription: message, fromVC: self, perform: perform)
        
    }
    
    @objc func finalise(){
        
        var message = ""
        if challenge.winner == MainUser.shared.userID{
            message = "Confirm that " + MainUser.shared.firstName! + " has won the challenge?"
        }
        else{
            message = "Confirm that " + challenge.userToChallenge.firstName! + " has won the challenge?"
        }
        
        let perform = {
            //delete challenge and swap payers in ladder
            self.showLoading()
                
            if self.challenge.userToChallenge.userID == self.challenge.winner{
                //loser is main user
                self.challenge.confirmWinner(winner: self.challenge.winner, loser: MainUser.shared.userID)
                self.challenge.delete()
                self.removeLoading()

                let perform = {
                    self.dismissMe()
                }
                Alert(withTitle: "Challenge completed", withDescription: "The challenge is complete", fromVC: self, perform: perform)
            }
            else{
                //loser is userToChallenge
                self.challenge.confirmWinner(winner: self.challenge.winner, loser: self.challenge.userToChallenge.userID)
                self.challenge.delete()

                self.removeLoading()
                let perform = {
                    self.dismissMe()
                }
                Alert(withTitle: "Challenge completed", withDescription: "The challenge is complete", fromVC: self, perform: perform)
            }
            
        }
        CancelAlert(withTitle: "Confirm", withDescription: message, fromVC: self, perform: perform)
        
        
        
        
    }
    
    @objc func reject(){
        challenge.reject()
        setupOngoing()
    }
    
    func dismissMe(){
        self.navigationController?.popViewControllers(viewsToPop: 1)
    }

}

