//
//  HomeMessageView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 12/01/2021.
//

import UIKit

class HomeMessageView: UIView{
    
    var presentingVC: HomeViewController!
    
    var topLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var bottomButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(btnClicked), for: .touchUpInside)
        return btn
    }()
    
    
    @objc func btnClicked(){
        print("yah")
       
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        self.isUserInteractionEnabled = true
        bottomButton.isUserInteractionEnabled = true
        
        
        self.addSubview(bottomButton)
        self.addSubview(topLabel)
       
        topLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

    

