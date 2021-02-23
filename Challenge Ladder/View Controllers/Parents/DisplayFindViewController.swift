//
//  DisplayFindViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 17/02/2021.
//

import UIKit
import FirebaseFunctions

class DisplayFindViewController: LoadingViewController, UITextFieldDelegate {

    var ladder: Ladder!
    var data = [UserCellData]()
    lazy var functions = Functions.functions()
    var findingFor: UserCellType!
    
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    var nothingFoundLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "No users found"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        return textLabel
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.view.backgroundColor = .background
        view.addSubview(tableView)
        self.view.addSubview(self.nothingFoundLabel)

        tableView.isHidden = true
        nothingFoundLabel.isHidden = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "usercell")
        tableView.delegate = self
        tableView.dataSource = self
        
        nothingFoundLabel.text = "No users found"
    
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        self.nothingFoundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview()
        }
        
        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.hideKeyboardWhenTappedAround()

    }
  

}

extension DisplayFindViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCell
        cell.button.removeTarget(nil, action: nil, for: .allEvents)
        
        cell.contentView.isUserInteractionEnabled = false // <<-- the solution


        cell.data = data[indexPath.row]
        cell.button.tag = indexPath.row
        cell.presentingVC = self
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nothing happens when user clicks on cell

    }
}
