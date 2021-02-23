//
//  SelectChallengeViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 03/09/2020.
//

import UIKit
import SnapKit
import FirebaseFirestore

class SelectChallengeViewController: BaseViewController {
        
    var noView: NoView!
    var challengeToShow: Challenge!
    
    var data = [ChallengeData]()
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    var amountOfChallengesLoaded: Int!


    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        amountOfChallengesLoaded = 0
        self.title = "Challenges"
        noView = NoView()
        noView.load(withText: "You have no ongoing challenges")
        noView.isHidden = false


        
        view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        tableView.register(SelectChallengeCell.self, forCellReuseIdentifier: "challengecell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                           #selector(handleRefreshControl),
                                           for: .valueChanged)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getChallenges()
    }
    
    @objc func handleRefreshControl() {
       // Update your content…

        if MainUser.shared.challenges.count == 0{
            noView.isHidden = false
            noView.isHidden = true
            removeLoading()
            self.view.addSubview(noView)
            noView.snp.makeConstraints { (make) in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            }
        }
        else{
            noView.isHidden = true
            tableView.isHidden = false
            for challenge in MainUser.shared.challenges{
                challengeToShow = Challenge(ref: challenge, completion: { [self] (completed) in
                    data.append(ChallengeData(personthechallengeiswith: self.challengeToShow.userToChallenge.firstName + " " + self.challengeToShow.userToChallenge.surname, laddername: self.challengeToShow.ladderName, challengeItself: challengeToShow))
                    amountOfChallengesLoaded += 1
                    if amountOfChallengesLoaded == MainUser.shared.challenges.count{
                        // Dismiss the refresh control.
                        amountOfChallengesLoaded = 0
                        DispatchQueue.main.async {
                           self.tableView.refreshControl?.endRefreshing()
                            tableView.reloadData()
                        }
                    }
                })
            }
        }
        
      
    }
    
    func getChallenges(){
       
        data.removeAll()
        showLoading()
        if MainUser.shared.challenges.count == 0{
            noView.isHidden = false
            tableView.isHidden = true
            removeLoading()
            self.view.addSubview(noView)
            noView.snp.makeConstraints { (make) in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            }
        }
        else{
            noView.isHidden = true
            tableView.isHidden = false
            for challenge in MainUser.shared.challenges{
                challengeToShow = Challenge(ref: challenge, completion: { [self] (completed) in
                    data.append(ChallengeData(personthechallengeiswith: self.challengeToShow.userToChallenge.firstName + " " + self.challengeToShow.userToChallenge.surname, laddername: self.challengeToShow.ladderName, challengeItself: challengeToShow))
                    amountOfChallengesLoaded += 1
                    if amountOfChallengesLoaded == MainUser.shared.challenges.count{
                        amountOfChallengesLoaded = 0
                        removeLoading()
                        tableView.reloadData()
                    }
                })
            }
        }
    }
}

extension SelectChallengeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
   
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengecell", for: indexPath) as! SelectChallengeCell
        
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       
        let challenge3 = data[indexPath.row].challengeItself
        let newVC = ChallengeViewController()
        newVC.previousVC = self
        newVC.challenge = challenge3
        self.navigationController?.pushViewController(newVC, animated: true)
    
    }
}
