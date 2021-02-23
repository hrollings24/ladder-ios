//
//  FindLadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 04/11/2020.
//

import UIKit

class FindViewController: LoadingViewController, UITextFieldDelegate {

    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    var nothingFoundLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "No ladders found"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        return textLabel
    }()

    var searchField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.placeholder = "Search for ladder"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.view.backgroundColor = .background
        view.addSubview(tableView)
        self.view.addSubview(self.nothingFoundLabel)

        tableView.isHidden = true
        nothingFoundLabel.isHidden = true
        
        searchField.delegate = self

        self.view.addSubview(searchField)
        
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalTo(-20)
            make.leading.equalTo(20)
            make.height.equalTo(30)
        }
        
        
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(searchField.snp.bottom).offset(20)
        }
        
        self.nothingFoundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.hideKeyboardWhenTappedAround()

    }

}


