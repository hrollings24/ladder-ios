//
//  NoChallengesView.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 08/10/2020.
//

import UIKit
import SnapKit

class NoLadderView: UIView{
    
    var presentingVC: UIViewController!
    
    var mainLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "You aren't participating in any ladders"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var createLadder: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create a ladder", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.blue, for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action:#selector(createLadderClicked), for: .touchUpInside)

        return btn
    }()
    
    var requestLadder: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join a ladder", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action:#selector(findLadderClicked), for: .touchUpInside)
        btn.backgroundColor = .clear
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(){
        self.addSubview(mainLabel)
        self.addSubview(createLadder)
        self.addSubview(requestLadder)

        mainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        createLadder.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.leading.equalTo(20)
            make.trailing.equalTo(-(self.frame.width / 2))

        }
        
        requestLadder.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.leading.equalTo(self.frame.width / 2)
            make.trailing.equalTo(-20)
        }
    }
    
    @objc func findLadderClicked(){
        let vc = FindLadderViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        presentingVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createLadderClicked(){
        let vc = CreateLadderViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        presentingVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func layoutSubviews() {
        mainLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        createLadder.snp.remakeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.leading.equalTo(20)
            make.trailing.equalTo(-(self.frame.width / 2))

        }
        
        requestLadder.snp.remakeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.leading.equalTo(self.frame.width / 2)
            make.trailing.equalTo(-20)
        }
    }
    
}
