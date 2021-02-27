//
//  BlackButton.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 27/02/2021.
//

import UIKit

class BlackButton: UIButton{
    
    init() {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 6
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
