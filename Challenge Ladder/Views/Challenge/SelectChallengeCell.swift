//
//  SelectChallengeCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 11/02/2021.
//

import UIKit

class SelectChallengeCell: UITableViewCell{
    
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
    
    var data: ChallengeData? {
        didSet {
            guard let data = data else { return }
            self.userToChallengeName.text = data.personthechallengeiswith
            self.challengeInLadderName.text = data.laddername
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.addSubview(userToChallengeName)
        self.addSubview(challengeInLadderName)
        self.addSubview(underlineView)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.userToChallengeName.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        self.challengeInLadderName.snp.remakeConstraints { (make) in
            make.top.equalTo(userToChallengeName.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        self.underlineView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(challengeInLadderName.snp.bottom).offset(5)
            make.height.equalTo(2)
        }
        
    }
    
}
