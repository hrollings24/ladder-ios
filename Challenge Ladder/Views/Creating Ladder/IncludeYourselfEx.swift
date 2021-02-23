//
//  IncludeYourselfEx.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 12/01/2021.
//

import UIKit

class IncludeYourselfEx: UIView{
    
    var label: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.text = "If you want to participate in the ladder as well as be an admin, select this box"
        return textLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.alpha = 0.8

        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
