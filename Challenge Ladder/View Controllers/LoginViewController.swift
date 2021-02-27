//
//  ViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 11/08/2020.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import FirebaseFunctions
import GoogleSignIn



class LoginViewController: LoadingViewController, UITextFieldDelegate {
    
    let siwaButton = ASAuthorizationAppleIDButton()
    var currentNonce: String!
    var firstName: String!
    var surname: String!
    var username: String!
    var email: String!
    var enterUsernameTextField: UITextField!
    lazy var functions = Functions.functions()
    
    let semaphore = DispatchSemaphore(value: 0)
    var usernameFound: Bool!
    let serialQueue = DispatchQueue(label: "Serial queue")

    var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    var usernameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "EMAIL"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var usernameTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var underlineViewForUsername: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var passwordLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "PASSWORD"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        return textLabel
    }()
    
    var passwordTextField: UITextField = {
        let textField =  UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    var forgotButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Forgot Password", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.charcoal, for: .normal)
        btn.contentHorizontalAlignment = .left;
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action:#selector(forgot), for: .touchUpInside)
        return btn
    }()
    
    var underlineViewForPassword: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    var loginButton: UIButton = {
        let btn = BlackButton()
        btn.setTitle("Login", for: .normal)
        btn.addTarget(self, action:#selector(loginClicked), for: .touchUpInside)
        return btn
    }()
    
    var signupBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up With Email", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.textAlignment = .left
        btn.setTitleColor(.charcoal, for: .normal)
        btn.addTarget(self, action:#selector(signUpClicked), for: .touchUpInside)
        return btn
    }()
    
    var siwgButton: UIButton = {
        let btn = BlackButton()
        btn.setTitle("Sign in with Google", for: .normal)
        btn.addTarget(self, action:#selector(googlesignInButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        keyboard()
        setupView()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    func setupView(){
        self.view.addSubview(imageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(underlineViewForUsername)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(forgotButton)
        self.view.addSubview(underlineViewForPassword)
        self.view.addSubview(loginButton)
        self.view.addSubview(signupBtn)
        self.view.addSubview(siwaButton)
        self.view.addSubview(siwgButton)


        siwaButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)

        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        self.view.backgroundColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .navBarColor
        self.title = ""


        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(100)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(imageView.snp.bottom).offset(40)
        }
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
        }
        
        underlineViewForUsername.snp.makeConstraints { (make) in
            make.width.equalTo(usernameTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameTextField.snp.bottom)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
        }
        
        underlineViewForPassword.snp.makeConstraints { (make) in
            make.width.equalTo(passwordTextField)
            make.height.equalTo(2)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(passwordTextField.snp.bottom)
        }
        
        forgotButton.snp.makeConstraints { (make) in
            make.width.equalTo(passwordTextField)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(forgotButton.snp.bottom).offset(20)
        }
        
        signupBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(siwgButton.snp.bottom).offset(10)
            
        }
        
        siwaButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(loginButton.snp.bottom).offset(10)
        }
        
        siwgButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width - 40)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(siwaButton.snp.bottom).offset(10)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func keyboard(){
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowSignUp), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideSignUp), name: UIResponder.keyboardWillHideNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowSignUp), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
       NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
       NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
       NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)

    }
      
    @objc func keyboardWillShowSignUp(notification: Notification) {
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           let amountToShift = (keyboardSize.height - (self.view.frame.height - (loginButton.frame.minY+loginButton.frame.height))) + 20
           if amountToShift > 0{
              self.view.frame.origin.y = -amountToShift
           }
       }
    }

    @objc func keyboardWillHideSignUp(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func signUpClicked(){
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginClicked(){
        //Check data has been entered
        if ((usernameTextField.text!.isEmpty)){
            Alert(withTitle: "Error", withDescription: "Please enter your details", fromVC: self, perform: {})
        }
        else if ((passwordTextField.text!.isEmpty)){
            Alert(withTitle: "Error", withDescription: "Please enter your details", fromVC: self, perform: {})
        }
        else{
            let db = Firestore.firestore()
            //If data is entered
            Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
                if error == nil{
                    UserDefaults.standard.set(true, forKey: "usersignedin")
                    UserDefaults.standard.synchronize()
                    
                    let user2 = Auth.auth().currentUser
                    MainUser.shared.getUser(withID: user2!.uid) { (completed) in
                        //LOAD NEXT VIEW NOW
                        db.collection("users").whereField("fcm", arrayContains: Messaging.messaging().fcmToken!).whereField("username", isEqualTo: MainUser.shared.username!).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                if querySnapshot!.documents.isEmpty {
                                    db.collection("users").document(MainUser.shared.userID).updateData([
                                        "fcm": FieldValue.arrayUnion([Messaging.messaging().fcmToken!])
                                    ])
                                }
                            }
                        }
                        
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "home") as? HomeViewController
                        homeVC!.modalPresentationStyle = .fullScreen
                        self?.dismiss(animated: true)
                    }
                }
                else{
                    let perform = {}
                    Alert(withTitle: "Error Occured", withDescription: error!.localizedDescription, fromVC: self!, perform: perform)
                }
            }
        }
        
        
    }
    
    @objc func forgot(){
        let vc = ForgotPasswordViewController()
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @objc func googlesignInButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func appleSignInTapped() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authoriseWithFirebase(usingCredential: AuthCredential){
        //User is loggin in with Google. they must add a username if it is a new account
        Auth.auth().signIn(with: usingCredential) { [self] (authResult, error) in
            //Do something after Firebase login completed
            if let error = error{
                Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: {})
            }
            else{
                if authResult!.additionalUserInfo!.isNewUser{
                    
                    if self.email == nil || self.firstName == nil || self.surname == nil{
                        Alert(withTitle: "Error", withDescription: "Unable to sign in with Apple. If you have recently deleted your account, please unlink your Apple ID from Ladder in your Apple ID Settings", fromVC: self, perform: {})
                    }
                    else{
                        usernameFound = false
                        usernameHasAResult(withCredential: usingCredential)
                        showUsername(withCredential: usingCredential)
                    }
                     
                }
                else{
                    //check if document is EMPTY
                    
                    
                    UserDefaults.standard.set(true, forKey: "usersignedin")
                    UserDefaults.standard.synchronize()
                    goHome()
                }
            }
        }
        
    }
    
    func showUsername(withCredential: AuthCredential){
        showUsernameAlert(withCredential: withCredential) { status in
            if status == .success{
                self.usernameFound = true
            }
            else if status == .userAborted{
                self.usernameFound = false
                Auth.auth().currentUser?.delete(completion: { error in
                    if let error = error{
                        Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: {})
                    }
                })
            }
            else{
                self.usernameFound = false
            }
            self.semaphore.signal()
        }
    }
    
    func usernameHasAResult(withCredential: AuthCredential){
        serialQueue.async {
            self.semaphore.wait()
            if self.usernameFound{
                //username is cool
                self.continueSignUp()
            }
            else{
                DispatchQueue.main.async {
                    print("I have arrived")
                }
            }
        }
    }
    
    
    
    func continueSignUp(){
        let userID = Auth.auth().currentUser?.uid
        let createinDB = CreateAccountInDB(username: username, firstName: firstName, surname: surname, userID: userID!)
        createinDB.createUser() { (result) in
            print(result)
            switch (result){
            case .usernameTaken:
                Alert(withTitle: "Username Taken", withDescription: "An unknown error occured", fromVC: self, perform: {})
            case .internalError:
                Alert(withTitle: "Error", withDescription: "An unknown error occured", fromVC: self, perform: {})
            case .success:
                UserDefaults.standard.set(true, forKey: "usersignedin")
                UserDefaults.standard.synchronize()
                self.goHome()
            case .userAborted:
                Alert(withTitle: "Error", withDescription: "An unknown error occured", fromVC: self, perform: {})

            }
        }
    }
    
    func goHome(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "home") as? HomeViewController
        homeVC!.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true)
    }
    
   
    
}


















extension LoginViewController : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // save the credential
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")

            // optional, might be nil
            self.email = appleIDCredential.email

            // optional, might be nil
            self.firstName = appleIDCredential.fullName?.givenName

            // optional, might be nil
            self.surname = appleIDCredential.fullName?.familyName
            
            
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
                authoriseWithFirebase(usingCredential: firebaseCredential)


            
           }
        
    }
        
       
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
}

extension LoginViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else { return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        self.firstName = user.profile.givenName
        self.surname = user.profile.familyName

        self.email = user.profile.email
        
        authoriseWithFirebase(usingCredential: credentials)
               
        
    }
}
