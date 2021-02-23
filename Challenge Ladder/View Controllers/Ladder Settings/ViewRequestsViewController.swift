//
//  ViewRequestsViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 21/11/2020.
//

import UIKit
import FirebaseFirestore

class ViewRequestsViewController: LoadingViewController {

    var ladder: Ladder!
    var settingsVC: LadderSettingsViewController!
    var data = [RequestCellData]()
    
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    var nothingFoundLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "You have no requests"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        return textLabel
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Requests"
       
        self.view.backgroundColor = .background
        view.addSubview(tableView)
        self.view.addSubview(self.nothingFoundLabel)

        tableView.isHidden = true
        nothingFoundLabel.isHidden = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(RequestCell.self, forCellReuseIdentifier: "requestcell")
        
        tableView.delegate = self
        tableView.dataSource = self
            
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        self.nothingFoundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension
                   
    }
    
    func setupView(withReference: DocumentReference){
        
        showLoading()
        Ladder(ref: withReference) { ladder in
            self.removeLoading()
            self.setupView(withLadder: ladder)
        }
        
    }
  

    func setupView(withLadder: Ladder){
        ladder = withLadder
        tableView.isHidden = true
        //if ladder has no users
        if ladder.requests.isEmpty{
            //display no requests
            self.nothingFoundLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                make.leading.trailing.equalToSuperview()
            }
            nothingFoundLabel.isHidden = false
        }
        else{
            var loadedRequestCount = 0
            showLoading()
            data.removeAll()
            for request in ladder.requests{
                //position is the userID
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(request)
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        let firstName = document.get("firstName") as! String
                        let surname = document.get("surname") as! String
                        let name = firstName + " " + surname
                        self.data.append(RequestCellData(name: name, username: document.get("username") as! String, user: userRef, userID: document.documentID, ladder: self.ladder))
                        loadedRequestCount += 1
                        if loadedRequestCount == self.ladder.requests.count{
                            self.removeLoading()
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                            self.nothingFoundLabel.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func refreshViews(){
        if settingsVC != nil{
            settingsVC.refreshText()
        }
        setupView(withLadder: ladder)
    }
}

extension ViewRequestsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestcell", for: indexPath) as! RequestCell
        
        cell.contentView.isUserInteractionEnabled = false // <<-- the solution

        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(acceptInvoked), for: .touchUpInside)
        cell.rejectButton.addTarget(self, action: #selector(rejectInvoked), for: .touchUpInside)


        cell.data = data[indexPath.row]
        cell.presentingVC = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nothing happens when user clicks on cell

    }
    
    
    @objc func rejectInvoked(_ sender: UIButton){
        print("reject")
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        print(indexPath)
    }
    
    @objc func acceptInvoked(_ sender: UIButton){
        print("accept")
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        print(indexPath)
        
    }
    
}
