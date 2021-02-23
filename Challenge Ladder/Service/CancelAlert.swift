//
//  CancelAlert.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/01/2021.
//

import Foundation
import UIKit

class CancelAlert{
    
    @discardableResult init(withTitle: String, withDescription: String, fromVC: UIViewController, perform: @escaping () -> Void){
        
        let alertController = UIAlertController(title: withTitle, message: withDescription, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
        
            perform()
        
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) {
                UIAlertAction in
        }
        
        alertController.addAction(noAction)

        alertController.addAction(actionOk)
        fromVC.present(alertController, animated: true, completion: nil)
    }

}
