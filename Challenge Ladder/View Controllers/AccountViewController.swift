//
//  AccountViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 24/10/2020.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseStorage
import Firebase
import LetterAvatarKit


class AccountViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var textField: UITextField!
    lazy var functions = Functions.functions()

    var firstNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = MainUser.shared.firstName + " " + MainUser.shared.surname
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var usernameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = MainUser.shared.username
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var changeUsernameBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Username", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(changeUsername), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var changeImage: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Profile Picture", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(changeProfilePicture), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var supportBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Email Support", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(emailSupport), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var deleteAccountBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete Account", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(deleteAccount), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    
    var profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = MainUser.shared.picture
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        setupView()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
    }
    
    func setupView(){
        
        self.view.addSubview(profilePicture)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(firstNameLabel)
        self.view.addSubview(deleteAccountBtn)
        self.view.addSubview(changeUsernameBtn)
        self.view.addSubview(supportBtn)
        self.view.addSubview(changeImage)
        
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        profilePicture.snp.makeConstraints { (make) in
            if (UIDevice.current.userInterfaceIdiom == .phone){
                make.width.equalTo(self.view.frame.width/4)
                make.height.equalTo(self.view.frame.width/4)
            }
            else{
                make.width.equalTo(self.view.frame.width/6)
                make.height.equalTo(self.view.frame.width/6)
            }

            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(20)
        }
        
        firstNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(profilePicture.snp.trailing).offset(20)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameLabel.snp.bottom)
            make.leading.equalTo(profilePicture.snp.trailing).offset(20)
        }
        
        changeUsernameBtn.snp.makeConstraints { (make) in
            make.top.equalTo(profilePicture.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        changeImage.snp.makeConstraints { (make) in
            make.top.equalTo(changeUsernameBtn.snp.bottom)
            make.leading.equalTo(20)
        }
        
        supportBtn.snp.makeConstraints { (make) in
            make.top.equalTo(changeImage.snp.bottom)
            make.leading.equalTo(20)
        }
        
        deleteAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(supportBtn.snp.bottom)
            make.leading.equalTo(20)
        }
        
    }
    
    @objc func emailSupport(){
        
    }
    
    @objc func changeProfilePicture(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]{
            selectedImage = editedImage as? UIImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage]{
            selectedImage = originalImage as? UIImage
        }
        
        if let confirmedImage = selectedImage {
            showLoading()
            //upload image to firebase
            let storageRef = Storage.storage().reference().child("profileimages/" + MainUser.shared.username + "Picture")
            
            let imageData = confirmedImage.pngData()! as Data
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if error != nil{
                    print(error!)
                    self.removeLoading()
                }
                else{
                    storageRef.downloadURL(completion: { url, error in
                        let db = Firestore.firestore()
                        let docRef = db.collection("users").document(MainUser.shared.userID)
                        docRef.updateData(["picture" : url!.absoluteString])
                        self.removeLoading()
                        self.profilePicture.image = confirmedImage
                    })
                }
            }

        }
        dismiss(animated: true, completion: nil)

    }
    
    @objc func deleteAccount(){
        let user = Auth.auth().currentUser

        // Check provider ID to verify that the user has signed in with Apple
        
            
        let deleteperform = {
            self.showLoading()
            
            user?.delete { error in
              if let error = error {
                print(error)
              } else {
                  let data = [
                      "userID": MainUser.shared.userID!
                  ] as [String : Any]
                  
                  self.functions.httpsCallable("deleteUser").call(data) { (result, error) in
                      self.removeLoading()
                      
                      if let error = error{
                          Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: {})
                      }
                      else{
                            let perform = {
                                //go to login page
                                UserDefaults.standard.setValue(false, forKey: "usersignedin")
                                self.moveToLogin()
                            }
                        Alert(withTitle: "Account Deleted", withDescription: "Your account has been deleted", fromVC: self, perform: perform)

                        }
                    }
                }
            }
        }
            
        CancelAlert(isDestructive: true, withTitle: "Delete Account", withDescription: "Are you sure you want to delete your account? This will delete any ladders you are the only admin of", fromVC: self, perform: deleteperform)
    }
    
    @objc func changeUsername(){
        let alert = UIAlertController(title: "Change Username", message: "Please enter a new username", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
            if self.textField.text != nil{
                //check username
                self.showLoading()
                let data = [
                    "username": self.textField.text!
                ] as [String : Any]
                
                self.functions.httpsCallable("checkUsername").call(data) { (result, error) in
                    let resultAsBool = result!.data as! Bool
                    if !resultAsBool{
                        Alert(withTitle: "Error", withDescription: "Username already taken", fromVC: self, perform: {})
                        self.removeLoading()
                    }
                    else{
                        //change username
                        MainUser.shared.changeUsername(to: self.textField.text!)
                        self.removeLoading()
                        self.usernameLabel.text = MainUser.shared.username
                        Alert(withTitle: "Success", withDescription: "Username changed", fromVC: self, perform: {})
                    }
                }
            }
            

        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    func configurationTextField(textField: UITextField!){
        self.textField = textField!
        textField.placeholder = "Enter username"
    }
    
}
