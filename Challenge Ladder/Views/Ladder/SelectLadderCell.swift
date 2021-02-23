//
//  SelectLadderCell.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 15/02/2021.
//

import UIKit

class SelectLadderCell: UITableViewCell{
    
    var ladder: Ladder!
    var presentingVC: LoadingViewController!
    
    var nameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    var data: LadderData? {
        didSet {
            guard let data = data else { return }
            self.nameLabel.text = data.nameofladder
            self.ladder = data.ladderitself
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.isUserInteractionEnabled = true

        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(underlineView)
        self.contentView.addSubview(blankView)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(underlineView.snp.top)

        }
        
        underlineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(blankView.snp.top)

        }
        
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(underlineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }


        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
       
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(underlineView.snp.top)

        }
        
        underlineView.snp.remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(blankView.snp.top)

        }
        
        blankView.snp.remakeConstraints { (make) in
            make.top.equalTo(underlineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
      
       
    }
    
    
    
}
