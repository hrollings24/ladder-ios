//
//  MenuViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/08/2020.
//

import UIKit

enum MenuType: Int{
    case account
    case logout
    case home
    case viewLadders
    case createLadder
    case viewchallenges
    case notifications
}

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    var didTapMenuType: ((MenuType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = MainUser.shared.firstName
        surnameLabel.text = MainUser.shared.surname
        

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        self.dismiss(animated: true) {
            self.didTapMenuType?(menuType)
        }
    }
}
