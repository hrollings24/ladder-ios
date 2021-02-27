//
//  BaseViewController.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 22/10/2020.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import AuthenticationServices
import NotificationCenter


class BaseViewController: LoadingViewController {
    
    let menuTransition = SlideInTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked(_:)), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)

        
        //navigationController?.navigationBar.isTranslucent = true
        //navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true

        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuPressed(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black

    }
    
    @objc func menuPressed(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        menuVC.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        let tap = UITapGestureRecognizer(target: self, action:    #selector(self.handleTap(_:)))
        menuTransition.dimmingView.addGestureRecognizer(tap)
        present(menuVC, animated: true)
    }
    
    func transitionToNew(_ menuType: MenuType){
        switch menuType{
        
        case .account:
            let vc = AccountViewController()
            present(viewController: vc)
            break
        case .logout:
            logout()
            break
        case .home:
            let vc = HomeViewController()
            present(viewController: vc)
            break
        case .viewLadders:
            let vc = SelectLadderViewController()
            present(viewController: vc)
            break
        case .createLadder:
            let vc = CreateLadderViewController()
            present(viewController: vc)
            break
        case .viewchallenges:
            let vc = SelectChallengeViewController()
            present(viewController: vc)
            break
        case .notifications:
            let vc = NotificationViewController()
            present(viewController: vc)
            break
        }
        
    }
    
    func present(viewController: BaseViewController){
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
          dismiss(animated: true, completion: nil)
    }
    
    func logout(){
        
        
        let currentUser = Auth.auth().currentUser

        do{
            try Auth.auth().signOut()
            //remove fcm
            
            // Check provider ID to verify that the user has signed in with Apple
               if let providerId = currentUser?.providerData.first?.providerID, providerId == "apple.com" {
                   // Clear saved user ID
                NotificationCenter.default.removeObserver(self, name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
                   UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
               }
            
            print(Messaging.messaging().fcmToken!)
            let db = Firestore.firestore()
            db.collection("users").document(MainUser.shared.userID).updateData([
                "fcm": FieldValue.arrayRemove([Messaging.messaging().fcmToken!])
            ])
            self.moveToLogin()
            UserDefaults.standard.setValue(false, forKey: "usersignedin")
            let alertController = UIAlertController(title: "Signed Out", message: "You successfully signed out", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                    UIAlertAction in
                
                    
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        catch let error {
            let perform = {}
            Alert(withTitle: "Error", withDescription: error.localizedDescription, fromVC: self, perform: perform)
        }

    }
    
    func moveToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let secondViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: secondViewController)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true)
    }
    
    @objc func appleIDStateDidRevoked(_ notification: Notification) {
        // Make sure user signed in with Apple
        let currentUser = Auth.auth().currentUser
        if
            let providerId = currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            logout()
        }
    }
    
  

    

}

extension BaseViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        menuTransition.isPresenting = true
        return menuTransition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        menuTransition.isPresenting = false
        return menuTransition
    }
    
   
}
