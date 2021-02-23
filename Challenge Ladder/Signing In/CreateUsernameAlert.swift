//
//  CreateUsernameAlert.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 18/02/2021.
//

import UIKit

class CreateUsernameAlert: UIAlertController{
    
    var textField: UITextField!
    
    init(){
        super.init(title: "Enter Username", message: "Please enter a new username", preferredStyle: .alert)
        
        self.addTextField(configurationHandler: configurationTextField)

        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            //User clicked enter
            if self.textField.text != nil{
                
            }
        }))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurationTextField(textField: UITextField!){
        self.textField = textField!
        textField.placeholder = "Enter username"
    }
    
}
