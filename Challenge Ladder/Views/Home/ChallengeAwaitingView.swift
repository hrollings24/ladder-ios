//
//  ChallengeAwaitingView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 12/01/2021.
//

import UIKit

class ChallengeAwaitingView: HomeMessageView{
        
    override func btnClicked(){
        
        let newVC = SelectChallengeViewController()
        presentingVC.navigationController?.pushViewController(newVC, animated: true)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if MainUser.shared.challenges.count == 1{
            topLabel.text = "You have 1 ongoing challenge"
            bottomButton.setTitle("View your challenge here", for: .normal)
        }
        else{
            topLabel.text = "You have " + String(MainUser.shared.challenges.count) + " ongoing challenges"
            bottomButton.setTitle("View your challenges here", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
