//
//  CreateUsername.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 18/02/2021.
//

import UIKit
import FirebaseAuth

extension LoginViewController{
        
    func showUsernameAlert(withCredential: OAuthCredential){
        let alert = UIAlertController(title: "Creare Username", message: "Please enter a new username", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            
            if self.enterUsernameTextField.text != nil{
                //check username
                self.showLoading()
                let data = [
                    "username": self.enterUsernameTextField.text!
                ] as [String : Any]
                
                self.functions.httpsCallable("checkUsername").call(data) { (result, error) in
                    let resultAsBool = result!.data as! Bool
                    if !resultAsBool{
                        Alert(withTitle: "Error", withDescription: "Username already taken", fromVC: self, perform: {})
                        self.removeLoading()
                        self.showUsernameAlert(withCredential: withCredential)
                    }
                    else{
                        self.username = self.enterUsernameTextField.text
                        self.signup(usingCredential: withCredential)
                    }
                }
            }
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }

    func configurationTextField(textField: UITextField!){
        self.enterUsernameTextField = textField!
        textField.placeholder = "Enter username"
    }
}
