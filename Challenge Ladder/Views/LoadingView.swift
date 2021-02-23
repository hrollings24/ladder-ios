//
//  Loading.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 01/11/2020.
//

import UIKit

class LoadingView: UIView{
    
    var activity: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        self.layer.cornerRadius = 10

        activity = UIActivityIndicatorView()
        activity.center = CGPoint(x: self.frame.size.width  / 2,
                                     y: self.frame.size.height / 2)
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.style = UIActivityIndicatorView.Style.medium
        self.addSubview(activity)
        activity.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func end(){
        activity.stopAnimating()
    }
    
}
