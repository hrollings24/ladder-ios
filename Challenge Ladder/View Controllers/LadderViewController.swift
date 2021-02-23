//
//  LadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 22/08/2020.
//

import UIKit
import FirebaseFirestore

class LadderViewController: LoadingViewController {

    var noLaddersLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "There are no users in the ladder! Invite users or set your ladder to public to allow other users to join"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    
    var ladder: Ladder!
    var usersInLadder: [LadderUser]!
    var selectLadderVC: UIViewController!
    var firstLoad: Bool!
    
    var data = [ladderData]()
    var myPos: Int!
    var challengeArray = [Int]()
    
    var selectedIndex: IndexPath? = IndexPath(row: -1, section: -1)
    
    var cornerButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .right
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstLoad = true

        myPos = 0
        ladder.updateScene = self
        title = ladder.name
        usersInLadder = [LadderUser]()
        
        if ladder.adminIDs.contains(MainUser.shared.userID){
            cornerButton.setTitle("Settings", for: .normal)
            cornerButton.addTarget(self, action:#selector(settingsInvoked), for: .touchUpInside)
        }
        else{
            cornerButton.setTitle("Invite Players", for: .normal)
            cornerButton.addTarget(self, action:#selector(inviteInvoked), for: .touchUpInside)
        }
        
        self.view.addSubview(cornerButton)
        
        cornerButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        

        
         view.addSubview(tableView)
         
         tableView.backgroundColor = .clear
         tableView.separatorStyle = .none

         tableView.snp.makeConstraints { (make) in
             make.leading.equalTo(30)
             make.trailing.equalTo(-30)
             make.bottom.equalToSuperview().offset(-20)
             make.top.equalTo(cornerButton.snp.bottom).offset(20)
         }
         
         tableView.register(LadderCell.self, forCellReuseIdentifier: "cell")
         
         tableView.delegate = self
         tableView.dataSource = self
        
        
        getUsersInLadder()
        configureRefreshControl()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstLoad == false{
            refreshupdate()
        }
    }
    
    func setupView(){
       
        
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }

    @objc func handleRefreshControl() {
       // Update your content…

        refreshupdate()
        
        DispatchQueue.main.async {
           self.tableView.refreshControl?.endRefreshing()
        }
        
       // Dismiss the refresh control.
       
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        ladder.updateScene = nil
    }
    
    @objc func inviteInvoked(){
        //check permissions
        if ladder.permission == .invitation || ladder.permission == .open{
                goToFindUser()
        }
        else{
            let perform = {}
            Alert(withTitle: "Permission Denied", withDescription: "Only admins can invite players", fromVC: self, perform: perform)
        }
    }
    
    func goToFindUser(){
        let vc = FindUserViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.ladder = ladder
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUsersInLadder(){
        
        if ladder.positions.isEmpty{
            //No users in ladder!
            //display no userd label
            self.view.addSubview(noLaddersLabel)
            noLaddersLabel.snp.makeConstraints { (make) in
                make.trailing.equalTo(-16)
                make.leading.equalTo(16)
                make.top.equalTo(cornerButton.snp.bottom).offset(20)
            }
        }
        else{
            var positionCounter = 1
            for userID in ladder.positions{
               
                usersInLadder.append(LadderUser(withID: userID, atPosition: positionCounter))
                positionCounter += 1
            }
            loadUserData()
        }
        
        
        
    }
    
    func loadUserData(){
        var amountOfUsersLoaded = 0
        for user in usersInLadder{
            user.loadUser { (isMe) in
                if isMe{
                    if self.firstLoad{
                        self.firstLoad = false
                        self.selectedIndex = IndexPath(row: user.position - 1, section: 0)
                    }
                    self.myPos = user.position
                }
                amountOfUsersLoaded += 1
                if amountOfUsersLoaded == self.usersInLadder.count{
                    //fully loaded users
                    self.loadData()
                }
            }
        }
    }
    
   
    
    
    func loadData(){
        for i in 1..<(ladder.jump + 1){
            challengeArray.append(myPos - i)
        }
        self.data.removeAll()
        for user in usersInLadder{
            data.append(ladderData(name: user.firstName + " " + user.surname, position: String(user.position), username: user.username, userID: user.userID))
        }
        self.tableView.reloadData()

       

    }
    
    
    @objc func settingsInvoked(){
        let vc = LadderSettingsViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.ladder = ladder
        
        vc.selectLadderVC = selectLadderVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func refreshupdate(){
        self.usersInLadder.removeAll()
        if ladder.adminIDs.contains(MainUser.shared.userID){
            cornerButton.setTitle("Settings", for: .normal)
            cornerButton.removeTarget(nil, action: nil, for: .allEvents)
            cornerButton.addTarget(self, action:#selector(settingsInvoked), for: .touchUpInside)
        }
        else{
            cornerButton.removeTarget(nil, action: nil, for: .allEvents)
            cornerButton.setTitle("Invite Players", for: .normal)
            cornerButton.addTarget(self, action:#selector(inviteInvoked), for: .touchUpInside)
        }
        self.getUsersInLadder()
    }
    
}


extension LadderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
   
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LadderCell
        cell.challengeBtn.removeTarget(nil, action: nil, for: .allEvents)

        cell.positions = challengeArray
        cell.ladder = ladder
        cell.presentingVC = self
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        cell.animate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return 200 }
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex != indexPath{
        
            selectedIndex = indexPath
        
            tableView.beginUpdates()
            tableView.reloadRows(at: [selectedIndex!], with: .none)
            tableView.endUpdates()
        }
    }
}


struct ladderData {
    var name: String
    var position: String
    var username: String
    var userID: String
}
