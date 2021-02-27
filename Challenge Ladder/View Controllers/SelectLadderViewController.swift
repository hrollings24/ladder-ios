//
//  SelectLadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 22/08/2020.
//

import UIKit
import SnapKit

class SelectLadderViewController: BaseViewController {
    
    var currentLadder: Ladder!
    var noView: NoLadderView!
    
    var data = [LadderData]()
    var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    var loadedLadderCount: Int!
    
    var cornerButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .right
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.setTitle("Find Ladders", for: .normal)
        btn.addTarget(self, action:#selector(searchLadder), for: .touchUpInside)
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noView = NoLadderView()
        noView.presentingVC = self
        
        loadedLadderCount = 0
        self.title = "Select Ladder"
        
        self.view.addSubview(cornerButton)
        
        cornerButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalTo(cornerButton.snp.bottom).offset(10)
        }
        
        self.view.addSubview(noView)
        noView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        noView.isHidden = true

        
        tableView.register(SelectLadderCell.self, forCellReuseIdentifier: "selectladdercell")
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                           #selector(handleRefreshControl),
                                           for: .valueChanged)
        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableView.automaticDimension

        getLadders()
       
    }
    
    @objc func handleRefreshControl() {
       // Update your content…

        data.removeAll()
        if MainUser.shared.ladders.count == 0{
            tableView.isHidden = true
            cornerButton.isHidden = true
            noView.isHidden = false
            removeLoading()
        }
        else{
            noView.isHidden = true
            cornerButton.isHidden = false
            tableView.isHidden = false
            for ladder in MainUser.shared.ladders{
                //ladder is DocumentReference
                Ladder(ref: ladder, completion: { [self] (completed) in
                    print(completed.name!)
                    data.append(LadderData(nameofladder: completed.name!, ladderitself: completed))
                    loadedLadderCount += 1
                    if loadedLadderCount == MainUser.shared.ladders.count{
                        loadedLadderCount = 0
                        print(data)
                        // Dismiss the refresh control.
                        DispatchQueue.main.async {
                           self.tableView.refreshControl?.endRefreshing()
                            tableView.reloadData()

                        }
                    }
                })
            }
        }
        
       
    }
    
    func getLadders(){
        
        showLoading()

        data.removeAll()
        if MainUser.shared.ladders.count == 0{
            tableView.isHidden = true
            self.view.addSubview(noView)
            cornerButton.isHidden = true
            removeLoading()
            noView.isHidden = false
        }
        else{
            noView.isHidden = true
            cornerButton.isHidden = false
            tableView.isHidden = false
            for ladder in MainUser.shared.ladders{
                print(ladder)
                //ladder is DocumentReference
                Ladder(ref: ladder, completion: { [self] (completed) in
                    print(completed.name!)
                    let ladderToADD = LadderData(nameofladder: completed.name!, ladderitself: completed)
                    let found = data.filter{$0.nameofladder == completed.name!}.count > 0
                    if !found{
                        data.append(ladderToADD)
                        loadedLadderCount += 1
                        if loadedLadderCount == MainUser.shared.ladders.count{
                            loadedLadderCount = 0
                            print(data)
                            removeLoading()
                            tableView.reloadData()
                        }
                    }
                    
                })
            }
        }
    }
    
    @objc func searchLadder(){
        let vc = FindLadderViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SelectLadderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
   
    
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectladdercell", for: indexPath) as! SelectLadderCell
        
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       
        let newladder = data[indexPath.row].ladderitself
        let newVC = LadderViewController()
        newVC.ladder = newladder
        self.navigationController?.pushViewController(newVC, animated: true)
    
    }
}
