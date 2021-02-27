//
//  UserButton.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 22/10/2020.
//

import UIKit

class UserButton: UIButton{
    var user: User!
    
    func add(user: User){
        self.user = user
        self.setTitle(user.username, for: .normal)
    }
}
