//
//  SignUpViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/08/2020.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import FirebaseMessaging

class SignUpViewController: LoadingViewController, UITextFieldDelegate {
    
    lazy var functions = Functions.functions()

    var welcomeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Welcome"
        textLabel.textColor = .white
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
    
    var createAccountLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Create An Account"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 28)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var usernameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "USERNAME"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var usernameTextField: UITextField = {
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
    
    var underlineViewForUsername: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var firstNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "FIRST NAME"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var firstNameTextField: UITextField = {
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
    
    var underlineViewForFirstName: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var surnameNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "SURNAME"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var surnameTextField: UITextField = {
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
    
    var underlineViewForSurname: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
    
    var passwordLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "PASSWORD"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var passwordTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var underlineViewForPassword: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var createAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .darkcharcoal
        btn.addTarget(self, action:#selector(createAccount), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .background
        
        self.navigationController?.navigationBar.backItem?.title = "Login"
        self.title = "Sign Up"
        
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(createAccountLabel)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(underlineViewForUsername)
        self.view.addSubview(firstNameLabel)
        self.view.addSubview(firstNameTextField)
        self.view.addSubview(underlineViewForFirstName)
        self.view.addSubview(surnameNameLabel)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(underlineViewForSurname)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(underlineViewForEmail)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(underlineViewForPassword)
        self.view.addSubview(createAccountButton)
        
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self

        usernameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
        }
        
        underlineViewForUsername.snp.makeConstraints { (make) in
            make.width.equalTo(usernameTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameTextField.snp.bottom)
        }
        
        firstNameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        firstNameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(firstNameLabel.snp.bottom).offset(10)
        }
        
        underlineViewForFirstName.snp.makeConstraints { (make) in
            make.width.equalTo(usernameTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(firstNameTextField.snp.bottom)
        }
        
        surnameNameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
        }
        
        surnameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(surnameNameLabel.snp.bottom).offset(10)
        }
        
        underlineViewForSurname.snp.makeConstraints { (make) in
            make.width.equalTo(usernameTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(surnameTextField.snp.bottom)
        }
        
        emailLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(surnameTextField.snp.bottom).offset(20)
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
        
        passwordLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
        }
        
        underlineViewForPassword.snp.makeConstraints { (make) in
            make.width.equalTo(passwordTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(passwordTextField.snp.bottom)
        }
        
        createAccountButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }

    }
    
    @objc func createAccount(){
        if usernameTextField.text?.isReallyEmpty ?? true || firstNameTextField.text?.isReallyEmpty ?? true || surnameTextField.text?.isReallyEmpty ?? true || emailTextField.text?.isReallyEmpty ?? true || passwordTextField.text?.isReallyEmpty ?? true{
            Alert(withTitle: "Error", withDescription: "Please complete all fields", fromVC: self, perform: {})
        }
        else{
            createUser(username: usernameTextField.text!, firstName: firstNameTextField.text!, surname: surnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        }
        
        
      
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func createUser(username: String, firstName: String, surname: String, email: String, password: String){
        
        
        
        //Check username doesn't already exist
        showLoading()
        let data = [
            "username": username
        ] as [String : Any]
        
        functions.httpsCallable("checkUsername").call(data) { (result, error) in
            let resultAsBool = result!.data as! Bool
            if !resultAsBool{
                Alert(withTitle: "Error", withDescription: "Username already taken", fromVC: self, perform: {})
                self.removeLoading()
            }
            else{
                self.goahead(username: username, firstName: firstName, surname: surname, email: email, password: password)
            }
        }
    }
    
    func goahead(username: String, firstName: String, surname: String, email: String, password: String){
        
        let ladders = [DocumentReference]()
        let challenges = [DocumentReference]()
        let db = Firestore.firestore()
        let perform = {}
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _eror = error {
                self.removeLoading()
                Alert(withTitle: "Error", withDescription: _eror.localizedDescription, fromVC: self, perform: perform)

            }else{
                //user registered successfully
                // Add a new document in collection "users"
                let fcmArray = [Messaging.messaging().fcmToken!]
                
                db.collection("users").document(authResult!.user.uid).setData([
                    "firstName": firstName,
                    "surname": surname,
                    "ladders": ladders,
                    "username": username.lowercased(),
                    "challenges": challenges,
                    "fcm": fcmArray
                    
                ]) { err in
                    if let err = err {
                        Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self, perform: perform)
                    } else {
                        
                        self.removeLoading()
                        self.presentHome()
                    }
                }
            }
        }
    }
    
    func presentHome(){
        let alertController = UIAlertController(title: "Account created", message: "Your account was successfully created", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
            
                let user2 = Auth.auth().currentUser
                MainUser.shared.getUser(withID: user2!.uid) { (completed) in
                    //LOAD NEXT VIEW NOW
                    UserDefaults.standard.set(true, forKey: "usersignedin")
                    UserDefaults.standard.synchronize()
                    self.navigationController?.dismiss(animated: true, completion: nil)

                }
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}