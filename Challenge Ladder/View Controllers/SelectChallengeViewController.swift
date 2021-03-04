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

        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension
        
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
        data.removeAll()
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
                 Challenge(ref: challenge, completion: { (theChallenge, challengeStatus) in
                    switch challengeStatus{
                    case .documentEmpty:
                        Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self, perform: {})
                        self.removeLoading()

                    case .success:
                        self.data.append(ChallengeData(personthechallengeiswith: theChallenge.userToChallenge.firstName + " " + theChallenge.userToChallenge.surname, laddername: theChallenge.ladderName, challengeItself: theChallenge))
                        
                        self.amountOfChallengesLoaded += 1
                        if self.amountOfChallengesLoaded == MainUser.shared.challenges.count{
                            self.amountOfChallengesLoaded = 0
                            self.removeLoading()
                            
                        }
                        
                    case .noDocument:
                        Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self, perform: {})
                        self.removeLoading()

                    case .errorRecievingUsers:
                        Alert(withTitle: "Error", withDescription: "Error retriving challenge participents", fromVC: self, perform: {})
                        self.removeLoading()

                    }
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    
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
                 Challenge(ref: challenge, completion: { (theChallenge, challengeStatus) in
                    switch challengeStatus{
                    case .documentEmpty:
                        Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self, perform: {})
                    
                    case .success:
                        self.data.append(ChallengeData(personthechallengeiswith: theChallenge.userToChallenge.firstName + " " + theChallenge.userToChallenge.surname, laddername: theChallenge.ladderName, challengeItself: theChallenge))
                        
                        self.amountOfChallengesLoaded += 1
                        if self.amountOfChallengesLoaded == MainUser.shared.challenges.count{
                            self.amountOfChallengesLoaded = 0
                            self.removeLoading()
                        }
                        
                    case .noDocument:
                        Alert(withTitle: "Error", withDescription: "Challenge not found", fromVC: self, perform: {})

                    case .errorRecievingUsers:
                        Alert(withTitle: "Error", withDescription: "Error retriving challenge participents", fromVC: self, perform: {})

                    }
                    self.tableView.reloadData()
                    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       
        let challenge3 = data[indexPath.row].challengeItself
        let newVC = ChallengeViewController()
        newVC.previousVC = self
        newVC.challenge = challenge3
        self.navigationController?.pushViewController(newVC, animated: true)
    
    }
}
