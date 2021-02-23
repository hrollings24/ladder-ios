//
//  Alert.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 17/07/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import UIKit

class Alert{
    
    @discardableResult init(withTitle: String, withDescription: String, fromVC: UIViewController, perform: @escaping () -> Void){
        
        let alertController = UIAlertController(title: withTitle, message: withDescription, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
        
            perform()
        
        }

        alertController.addAction(actionOk)
        fromVC.present(alertController, animated: true, completion: nil)
    }

}
