//
//  LoadingViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 21/11/2020.
//

import UIKit

class LoadingViewController: UIViewController {

    var loadView: LoadingView!
    var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = .background
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "image")//if its in images.xcassets
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
            
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
        
        adjustLargeTitleSize()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    

    func showLoading(){
        let sizeOfView = CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 - 50, width: 100, height: 100)
        loadView = LoadingView(frame: sizeOfView)
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(loadView)
    }
    
    func removeLoading(){
        loadView.end()
        self.view.isUserInteractionEnabled = true
        loadView.removeFromSuperview()
    }
}

