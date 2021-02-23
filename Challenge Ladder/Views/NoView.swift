//
//  NoView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 10/10/2020.
//

import UIKit
import SnapKit

class NoView: UIView{
    
    var mainLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(withText: String){
        self.addSubview(mainLabel)

        mainLabel.text = withText
        mainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
    }
    
}
