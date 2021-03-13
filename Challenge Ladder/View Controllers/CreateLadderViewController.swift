//
//  CreateLadderViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 15/08/2020.
//

import UIKit
import FirebaseFirestore


class CreateLadderViewController: BaseViewController, UITextFieldDelegate {
            
    var ladder: Ladder!
    var backgroundBlur: UIView = {
        let blur = UIView()
        blur.backgroundColor = .black
        blur.alpha = 0.5
        return blur
    }()
    
    var popup: UIView!
    
    var ladderNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "LADDER NAME"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var ladderNameTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var underlineViewForLadderName: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var amountLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "POSITIONS"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var amountTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.line
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.textAlignment = .center
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var positionsInfo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "info.circle")
        imgView.tintColor = .black
        return imgView
    }()
    
    var includeMeInfo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "info.circle")
        imgView.tintColor = .black
        return imgView
    }()
    
    var createLadderButton: UIButton = {
        let btn = BlackButton()
        btn.setTitle("Create Ladder", for: .normal)
        btn.addTarget(self, action:#selector(createdPressed), for: .touchUpInside)
        return btn
    }()
    
    var includeMeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "INCLUDE YOURSELF"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var includeMeSwitch: UISwitch = {
        let switchMe = UISwitch()
        return switchMe
    }()
    
    var permissionsLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "PERMISSIONS"
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var permissionsTextField: PermissionsTextField!

  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Ladder"
        permissionsTextField = PermissionsTextField()
        
        positionsInfo.isUserInteractionEnabled = true
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(positionsTapped))
        //Add the recognizer to your view.
        positionsInfo.addGestureRecognizer(tapRecognizer)
        
        
        includeMeInfo.isUserInteractionEnabled = true
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(includeTapped))
        //Add the recognizer to your view.
        includeMeInfo.addGestureRecognizer(tapRecognizer2)

        setupView()

        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        self.view.addSubview(ladderNameLabel)
        self.view.addSubview(ladderNameTextField)
        self.view.addSubview(underlineViewForLadderName)
        self.view.addSubview(amountLabel)
        self.view.addSubview(amountTextField)
        self.view.addSubview(positionsInfo)
        self.view.addSubview(createLadderButton)
        self.view.addSubview(includeMeSwitch)
        self.view.addSubview(includeMeInfo)
        self.view.addSubview(includeMeLabel)
        self.view.addSubview(permissionsLabel)
        self.view.addSubview(permissionsTextField)
        self.view.addSubview(backgroundBlur)

        backgroundBlur.isHidden = true
        backgroundBlur.layer.zPosition = 3
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(endPopup))
        backgroundBlur.addGestureRecognizer(tapGesture)
        
        
        backgroundBlur.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        ladderNameTextField.delegate = self
        amountTextField.delegate = self
        
        ladderNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        ladderNameTextField.snp.makeConstraints { (make) in
            make.trailing.equalTo((-20))
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.top.equalTo(ladderNameLabel.snp.bottom).offset(10)
        }
        underlineViewForLadderName.snp.makeConstraints { (make) in
            make.trailing.equalTo((-20))
            make.leading.equalTo(20)
            make.width.equalTo(ladderNameTextField)
            make.height.equalTo(2)
            make.top.equalTo(ladderNameTextField.snp.bottom)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(underlineViewForLadderName.snp.bottom).offset(20)
        }
        
        amountTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(positionsInfo.snp.trailing).offset(20)
            make.height.equalTo(amountLabel)
            make.width.equalTo(70)
            make.top.equalTo(underlineViewForLadderName.snp.bottom).offset(20)
        }
        
        positionsInfo.snp.makeConstraints { (make) in
            make.leading.equalTo(amountLabel.snp.trailing).offset(10)
            make.height.equalTo(amountLabel)
            make.width.equalTo(amountLabel.snp.height)
            make.top.equalTo(underlineViewForLadderName.snp.bottom).offset(20)
        }
        
        includeMeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
        }
        
        includeMeInfo.snp.makeConstraints { (make) in
            make.leading.equalTo(includeMeLabel.snp.trailing).offset(10)
            make.height.equalTo(includeMeLabel)
            make.width.equalTo(includeMeLabel.snp.height)
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
        }
        
        includeMeSwitch.snp.makeConstraints { (make) in
            make.leading.equalTo(includeMeInfo.snp.trailing).offset(20)
            make.height.equalTo(includeMeLabel)
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
        }
       
        permissionsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(includeMeSwitch.snp.bottom).offset(20)
        }
        
        permissionsTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(permissionsLabel.snp.trailing).offset(20)
            make.height.equalTo(permissionsLabel)
            make.width.equalTo(100)
            make.top.equalTo(includeMeSwitch.snp.bottom).offset(20)
        }
        
        createLadderButton.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(permissionsLabel.snp.bottom).offset(20)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountTextField.resignFirstResponder()

    }
    
    @objc func createdPressed(){
        let db = Firestore.firestore()

        if permissionsTextField.text?.isReallyEmpty ?? true || ladderNameTextField.text?.isReallyEmpty ?? true || amountTextField.text?.isReallyEmpty ?? true{
            Alert(withTitle: "Error", withDescription: "Please complete all fields", fromVC: self, perform: {})
        }
        else{
            //check if ladder name already exists
            let ref = db.collection("ladders").whereField("name", isEqualTo: ladderNameTextField.text!.lowercased())
            ref.getDocuments { snapshot, error in
                if let error = error{
                    Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: {})
                }
                else{
                    if let snapshot = snapshot{
                        if snapshot.isEmpty{
                            self.createLadder()
                        }
                        else{
                            Alert(withTitle: "Name Taken", withDescription: "A ladder with your chosen name already exists. Please choose a new name", fromVC: self, perform: {})
                        }
                    }
                    else{
                        Alert(withTitle: "Error", withDescription: "An unknown error occured", fromVC: self, perform: {})

                    }
                }
            }

            
        }
        
    }
    
    
    func createLadder(){
        
        
        
        
        let permissions = permissionsTextField.text
        let name = ladderNameTextField.text!.lowercased()
        var adminIDs = [String]()
        adminIDs.append(MainUser.shared.userID)
        let jump = Int(amountTextField.text!)
        let requests = [String]()
        var positions = [String]()
        if includeMeSwitch.isOn{
            positions.append(MainUser.shared.userID)
        }

        showLoading()
        //create ladder
        
        let db = Firestore.firestore()

        let ref = db.collection("ladders").document()
        ref.setData([
            "permission": permissions!,
            "name": name,
            "admins": adminIDs,
            "requests": requests,
            "jump": jump!,
            "positions": positions
        ]) { err in
            if let err = err {
                let perform = {}
                Alert(withTitle: "Error", withDescription: err.localizedDescription, fromVC: self, perform: perform)
            } else {
                db.collection("users").document(MainUser.shared.userID).updateData([
                    "ladders": FieldValue.arrayUnion([ref])
                ])
                
                Ladder(ref: ref) { result in
                    switch result{
                    case .success(let data):
                        self.ladder = data
                        if data.initialising{
                            self.removeLoading()
                            let alertController = UIAlertController(title: "Success", message: "Ladder successfully created", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) {
                                    UIAlertAction in
                                self.goToLadder()
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        Alert(withTitle: "Error", withDescription: error.rawValue, fromVC: self, perform: {})
                    }
                }
            }
        }
    }
    

    
    func goToLadder(){
        let newVC = LadderViewController()
        newVC.ladder = ladder
        newVC.selectLadderVC = self
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func positionsTapped(){
        popup = PositionsEx()
        addPopup()
    }
    
    @objc func includeTapped(){
        popup = IncludeYourselfEx()
        addPopup()
    }
    
    func addPopup(){
        backgroundBlur.isHidden = false

        popup.layer.zPosition = 4
        self.view.addSubview(popup)
        popup.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.bounds.height / 3)
            make.height.equalTo(100)
            make.trailing.equalTo(-20)
            make.leading.equalTo(20)
        }
    }
    
    @objc func endPopup(){
        
        popup.removeFromSuperview()
        backgroundBlur.isHidden = true
        
    }
    
}
