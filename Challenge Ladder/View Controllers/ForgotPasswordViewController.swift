//
//  ForgotPasswordViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 08/10/2020.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: LoadingViewController, UITextFieldDelegate {
    
    var welcomeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Forgot Password"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 32)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var welcomeLabelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .navBarColor
        return view
    }()
    
    
    var emailLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "EMAIL"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var emailTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var underlineViewForEmail: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action:#selector(submitClicked), for: .touchUpInside)
        return btn
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background
        emailTextField.delegate = self
        
        self.view.addSubview(welcomeLabelBackgroundView)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(underlineViewForEmail)
        self.view.addSubview(submitButton)
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(50)
        }
        
        welcomeLabelBackgroundView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(welcomeLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(welcomeLabelBackgroundView.snp.bottom).offset(20)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
        }
        
        underlineViewForEmail.snp.makeConstraints { (make) in
            make.width.equalTo(emailTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(emailTextField.snp.bottom)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(underlineViewForEmail.snp.bottom).offset(20)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    @objc func submitClicked(){
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            let perform = {}

            if error == nil{
                //success
                Alert(withTitle: "Success", withDescription: "Please check your email for a password reset link", fromVC: self, perform: perform)
            }
            else{
                //failure
                Alert(withTitle: "Error occured", withDescription: error!.localizedDescription, fromVC: self, perform: perform)
            }
        }
    }
    
    
    
}
