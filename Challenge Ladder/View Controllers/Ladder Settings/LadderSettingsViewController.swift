//
//  LadderSettingsViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 02/11/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseFunctions

class LadderSettingsViewController: LoadingViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var ladder: Ladder!
    var picker: UIPickerView!
    var textfield: UITextField!
    var tempPermission: LadderPermission!
    lazy var functions = Functions.functions()
    var selectLadderVC: UIViewController!
    
    var enterUsernameTextField: UITextField!
    
    var ladderName: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 28)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var adminLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Admin Settings"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var userLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "User Settings"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var ladderLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Ladder Settings"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var permissionsLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var addAdminsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Admins", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(adminInvoked), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        return btn
    }()
    
    var inviteUsersButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Invite Users", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(inviteInvoked), for: .touchUpInside)
        return btn
    }()
    
    var viewUserListButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("View Users", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(viewUsers), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var viewAdminsListButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("View Admins", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(viewAdmins), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var viewRequestsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("View Requests", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(viewRequestsInvoked), for: .touchUpInside)

        return btn
    }()
    
    var permissionsBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Permissions", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)

        return btn
    }()
    
    var changeName: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Name", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(nameClicked), for: .touchUpInside)

        return btn
    }()
    
    var changeJump: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Jump", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action:#selector(jumpClicked), for: .touchUpInside)

        return btn
    }()
    
    var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete Ladder", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(confirmDeletion), for: .touchUpInside)

        btn.backgroundColor = .clear
        return btn
    }()
    
    func refreshText(){
        viewRequestsButton.setTitle("View " + String(ladder.requests.count) + " pending requests", for: .normal)
        ladderName.text = ladder.name
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ladder.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ladder.updateSettings = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .background
        self.title = "Settings"
        
        self.view.addSubview(addAdminsButton)
        self.view.addSubview(inviteUsersButton)
        self.view.addSubview(viewUserListButton)
        self.view.addSubview(viewRequestsButton)
        self.view.addSubview(permissionsBtn)
        self.view.addSubview(ladderName)
        self.view.addSubview(changeJump)
        self.view.addSubview(viewAdminsListButton)
        self.view.addSubview(deleteButton)
        self.view.addSubview(adminLabel)
        self.view.addSubview(userLabel)
        self.view.addSubview(permissionsLabel)
        self.view.addSubview(ladderLabel)
        self.view.addSubview(changeName)




        ladderName.text = ladder.name

        ladderName.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        adminLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ladderName.snp.bottom).offset(30)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        addAdminsButton.snp.makeConstraints { (make) in
            make.top.equalTo(adminLabel.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        viewAdminsListButton.snp.makeConstraints { (make) in
            make.top.equalTo(addAdminsButton.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        userLabel.snp.makeConstraints { (make) in
            make.top.equalTo(viewAdminsListButton.snp.bottom).offset(20)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        viewRequestsButton.setTitle("View " + String(ladder.requests.count) + " pending requests", for: .normal)
        viewRequestsButton.snp.makeConstraints { (make) in
            make.top.equalTo(userLabel.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        inviteUsersButton.snp.makeConstraints { (make) in
            make.top.equalTo(viewRequestsButton.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        viewUserListButton.snp.makeConstraints { (make) in
            make.top.equalTo(inviteUsersButton.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        ladderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(viewUserListButton.snp.bottom).offset(30)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        permissionsLabel.text = "Current Permission: " + ladder.permission.rawValue
        permissionsLabel.numberOfLines = 0
        permissionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ladderLabel.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        permissionsBtn.snp.makeConstraints { (make) in
            make.top.equalTo(permissionsLabel.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        changeJump.snp.makeConstraints { (make) in
            make.top.equalTo(permissionsBtn.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        changeName.snp.makeConstraints { (make) in
            make.top.equalTo(changeJump.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(changeName.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)

        }
        
     
        showPickerView()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ladder.updateSettings = nil
    }
    

    @objc func inviteInvoked(){
        let vc = FindUserViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.ladder = ladder
        vc.findingFor = .user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func adminInvoked(){
        let vc = FindUserViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.ladder = ladder
        vc.findingFor = .admin
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewRequestsInvoked(){
        let vc = ViewRequestsViewController()
        vc.setupView(withLadder: ladder)
        vc.settingsVC = self
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPickerView(){
    
        textfield = UITextField()
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
        
        textfield = UITextField()
        textfield.isHidden = true
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickerCancelled))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textfield.inputView = picker
        textfield.inputAccessoryView = toolBar
        
        self.view.addSubview(textfield)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return LadderPermission.allCases[row].rawValue
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        LadderPermission.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempPermission = LadderPermission.allCases[row]
    }
    
    @objc func pickerDone() {
        //change the permission
        if tempPermission == nil{
            tempPermission = .open
        }
        let db = Firestore.firestore()
        let docRef = db.collection("ladders").document(ladder.id)
        docRef.updateData(["permission" : tempPermission.rawValue])
        permissionsLabel.text = "Current Permission: " + tempPermission.rawValue

        
        textfield.resignFirstResponder()
    }
    
    @objc func pickerCancelled() {
        textfield.resignFirstResponder()
    }
    
    @objc func buttonClicked() {
        textfield.becomeFirstResponder()
    }
    
    @objc func jumpClicked(){
        let vc = ChangeJumpViewController()
        vc.ladder = ladder
        if UIDevice.current.userInterfaceIdiom == .pad{
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else{
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)

        }
       
    }
    
    @objc func nameClicked(){
        changeNameAlert()
        
    }
    
    @objc func viewUsers(){
        let vc = ViewUsersInLadderViewController()
        vc.ladder = ladder
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func viewAdmins(){
        let vc = ViewAdminsInLadderViewController()
        vc.ladder = ladder
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    
    @objc func confirmDeletion(){
        let perform = {
            
            
            let data = ["ladderID": self.ladder.id]
            self.showLoading()

            self.functions.httpsCallable("deleteLadder").call(data) { (result, error) in
                self.removeLoading()
                if let error = error{
                   print("An error occurred while calling the function: \(error)" )
                }
                else{
                    let resultData = result!.data as! NSDictionary
                    let perform2: () -> Void = {
                        self.navigationController?.popViewControllers(viewsToPop: 2)
                    }

                    Alert(withTitle: resultData["title"]! as! String, withDescription: resultData["message"]! as! String, fromVC: self, perform: perform2)
                    
                }
            }
            
        }
        
        
        CancelAlert(withTitle: "Delete Ladder", withDescription: "Confirm you want to delete this ladder", fromVC: self, perform: perform)
    }
    
    
    func changeNameAlert(){
        
        
        let alert = UIAlertController(title: "Change Name", message: "Please enter a new name", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            
            if self.enterUsernameTextField.text != nil{
                //check username
                self.showLoading()
                let data = [
                    "name": self.enterUsernameTextField.text!.lowercased()
                ] as [String : Any]
                
                self.functions.httpsCallable("checkName").call(data) { (result, error) in
                    let resultAsBool = result!.data as! Bool
                    if let error = error{
                        Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: {})
                    }
                    if !resultAsBool{
                        Alert(withTitle: "Error", withDescription: "Name already taken", fromVC: self, perform: {})
                        self.removeLoading()
                    }
                    else{
                        self.ladder.updateName(to: self.enterUsernameTextField.text!)
                        self.removeLoading()
                    }
                }
            }
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func configurationTextField(textField: UITextField!){
        self.enterUsernameTextField = textField!
        textField.placeholder = "Enter name"
    }
    
}
