//
//  NoLaddersView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 12/01/2021.
//

import UIKit

class NoLaddersView: HomeMessageView{
        
    override func btnClicked(){
        
        let newVC = SelectLadderViewController()
        presentingVC.navigationController?.pushViewController(newVC, animated: true)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topLabel.text = "You aren't in any ladders"
        bottomButton.setTitle("Join or create a ladder here", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
