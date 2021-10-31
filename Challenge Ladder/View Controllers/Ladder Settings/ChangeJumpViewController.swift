//
//  ChangeJumpViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/01/2021.
//

import UIKit
import FirebaseFirestore

class ChangeJumpViewController: LoadingViewController, UITextFieldDelegate {
    
    var ladder: Ladder!
    
    var welcomeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Change Jump"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 32)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var amountLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Positions: "
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var amountTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.line
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.textAlignment = .center
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Confirm", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action:#selector(submitClicked), for: .touchUpInside)
        return btn
    }()
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountTextField.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(amountLabel)
        self.view.addSubview(amountTextField)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(submitButton)
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
        }
        
        amountTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(amountLabel.snp.trailing).offset(20)
            make.height.equalTo(amountLabel)
            make.width.equalTo(70)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(40)
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    @objc func submitClicked(){
        if amountTextField.text!.isEmpty{
            Alert(withTitle: "Error", withDescription: "Please enter an amount", fromVC: self, perform: {})
        }
        else{
            let perform = {
                self.ladder.updateJump(to: Int(self.amountTextField.text!)!)
                let dismissperform = {
                    self.dismiss(animated: true)
                }
                Alert(withTitle: "Success", withDescription: "The jump was changed", fromVC: self, perform: dismissperform)
            }
            CancelAlert(isDestructive: false, withTitle: "Confirm", withDescription: "Please confirm you want to change the jump", fromVC: self, perform: perform)
        }
    }
    
    
    
}
