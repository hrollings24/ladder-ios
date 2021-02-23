//
//  SelectChallengeView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 03/09/2020.
//

import UIKit
import FirebaseFirestore

class SelectChallengeView: UIView{
    
    var vc: UIViewController!
    var activity: UIActivityIndicatorView!
    
    var challenge: Challenge!
    
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
    
    var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func didLoad(withChallenge: DocumentReference, completion: @escaping(Bool)->()) {
        self.challenge = Challenge(ref: withChallenge, completion: { [self] (completed) in
            self.addSubview(self.userToChallengeName)
            self.addSubview(self.challengeInLadderName)
            self.addSubview(self.underlineView)
            
            self.userToChallengeName.text = self.challenge.userToChallenge.firstName + " " + self.challenge.userToChallenge.surname
            self.challengeInLadderName.text = self.challenge.ladderName!
            
            self.userToChallengeName.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
            }
            self.challengeInLadderName.snp.makeConstraints { (make) in
                make.top.equalTo(userToChallengeName.snp.bottom).offset(5)
                make.leading.trailing.equalToSuperview()
            }
            self.underlineView.snp.makeConstraints { (make) in
                make.bottom.leading.trailing.equalToSuperview()
                make.height.equalTo(2)
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.addGestureRecognizer(tap)
            completion(true)
        })
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let newVC = ChallengeViewController()
        newVC.challenge = challenge
        vc.navigationController?.pushViewController(newVC, animated: true)
    }
    
  
    
}
