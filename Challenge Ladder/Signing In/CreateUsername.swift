//
//  CreateUsername.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 18/02/2021.
//

import UIKit
import FirebaseAuth

extension LoginViewController{
    
        
    func showUsernameAlert(withCredential: OAuthCredential, completion: @escaping (CreatingAccountStatus)->()){
        
        
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
                        completion(.usernameTaken)
                    }
                    else{
                        self.username = self.enterUsernameTextField.text
                        self.removeLoading()
                        completion(.success)
                    }
                }
            }
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func showUsernameAlert(withCredential: AuthCredential, completion: @escaping (CreatingAccountStatus)->()){
        let alert = UIAlertController(title: "Creare Username", message: "Please enter a new username", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction)in
            completion(.userAborted)
        }))
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
                        Alert(withTitle: "Error", withDescription: "Username already taken", fromVC: self, perform: {
                            //show the alert AGAIN
                            self.present(alert, animated: true, completion: {
                                
                            })
                        })
                        self.removeLoading()
                        completion(.usernameTaken)
                    }
                    else{
                        self.username = self.enterUsernameTextField.text
                        self.removeLoading()
                        completion(.success)
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
