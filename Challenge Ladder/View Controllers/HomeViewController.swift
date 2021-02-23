//
//  HomeViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 13/08/2020.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: BaseViewController {
    
    var welcomeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Welcome"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 30)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
    
    var messageView: HomeMessageView!

    
    var makeprogresslabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Make progress today."
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.numberOfLines = 2
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var climbladderlabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Climb your ladder."
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.numberOfLines = 2
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var activity: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Home"
        checkPermissions()
    }
    
  
    func checkPermissions(){
        if UserDefaults.standard.bool(forKey: "usersignedin") {
            //user is logged in
            activity = UIActivityIndicatorView()
            activity.center = self.view.center
            activity.hidesWhenStopped = true
            activity.style = UIActivityIndicatorView.Style.medium
            self.view.addSubview(activity)
            activity.startAnimating()

            let user2 = Auth.auth().currentUser
            MainUser.shared.getUser(withID: user2!.uid) { (completed) in
                self.activity.stopAnimating()
                self.setupView()
            }
        }
        else{
            //login
            moveToLogin()
        }
    }
    
  

    func setupView(){
            
        self.view.addSubview(imageView)
        self.view.addSubview(makeprogresslabel)
        self.view.addSubview(climbladderlabel)

      
        imageView.layer.zPosition = 1
        welcomeLabel.layer.zPosition = 2
        makeprogresslabel.layer.zPosition = 2
        climbladderlabel.layer.zPosition = 2
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation

        if UIDevice.current.userInterfaceIdiom == .pad{
            if orientation!.isPortrait{
                let image = UIImage(named: "ipad-portrait")
                imageView.image = image
            }
            else{
                let image = UIImage(named: "ipad-landscape")
                imageView.image = image
            }

        }
        else{
            let image = UIImage(named: "iphone-background")
            imageView.image = image

        }
        
        imageView.snp.makeConstraints { (make) in
            make.bottom.trailing.leading.equalToSuperview()
            make.top.equalTo(0)
        }
        
        

        if UIDevice.current.userInterfaceIdiom == .pad{
            if orientation!.isPortrait {
                makeprogresslabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.width / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo((self.view.frame.height / 2) )
                }
                
                climbladderlabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.width / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(makeprogresslabel.snp.bottom)
                }
                
            }
            else {
                makeprogresslabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.width / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo((self.view.frame.height / 2) )
                }
                
                climbladderlabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.width / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(makeprogresslabel.snp.bottom)
                }

            }
           
        }
        else{
            makeprogresslabel.snp.makeConstraints { (make) in
                make.leading.equalTo((self.view.bounds.width / 20 ) * 9)
                make.trailing.equalTo(-20)
                make.top.equalTo((self.view.frame.height / 2) )
            }
            
            climbladderlabel.snp.makeConstraints { (make) in
                make.leading.equalTo((self.view.bounds.width / 20 ) * 9)
                make.trailing.equalTo(-20)
                make.top.equalTo(makeprogresslabel.snp.bottom)
            }
        }
        
        
       
        
        
        checkForChallenges()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            if orientation!.isLandscape {
                imageView.image = UIImage(named: "ipad-landscape")
                if messageView != nil{
                    messageView.snp.remakeConstraints { (make) in
                        make.leading.equalTo(self.view.frame.height / 2)
                        make.trailing.equalTo(-16)
                        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                        make.height.equalTo(100)
                    }
                }
                makeprogresslabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.height / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo((self.view.frame.width / 2) )
                }
                
                climbladderlabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.bounds.height / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(makeprogresslabel.snp.bottom)
                }
               
                
            }
            else {
                imageView.image = UIImage(named: "ipad-portrait")
                if messageView != nil{
                    messageView.snp.updateConstraints { (make) in
                        make.leading.equalTo(16)
                        make.trailing.equalTo(-16)
                        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                        make.height.equalTo(80)
                    }
                }
                makeprogresslabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.frame.height / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo((self.view.frame.height / 3) * 2)
                }
                
                climbladderlabel.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.frame.height / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(makeprogresslabel.snp.bottom)
                }
               
               
            }
        }
           
    }
    
    
   
    

    func checkForChallenges(){
        if messageView != nil{
            messageView.removeFromSuperview()
            messageView = nil
        }
        if !MainUser.shared.challenges.isEmpty{
            //add challenges
            messageView = ChallengeAwaitingView()
        }
        else if !MainUser.shared.ladders.isEmpty{
            //add ladders
            messageView = ViewLaddersView()
        }
        else{
            //user is not in a ladder. Create or join a ladder
            messageView = NoLaddersView()
        }
        
        self.view.addSubview(messageView)
        messageView.isUserInteractionEnabled = true
        messageView.presentingVC = self
        messageView.layer.zPosition = 2
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            if orientation!.isLandscape{
                messageView.snp.remakeConstraints { (make) in
                    make.leading.equalTo(self.view.frame.width / 2)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                    make.height.equalTo(100)
                }
            }
            else{
                messageView.snp.makeConstraints { (make) in
                    make.leading.equalTo(16)
                    make.trailing.equalTo(-16)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                    make.height.equalTo(80)
                }
            }
        }
        else{
            messageView.snp.makeConstraints { (make) in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                make.height.equalTo(80)
            }
        }
        


    }
    
}
