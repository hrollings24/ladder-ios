//
//  AppDelegate.swift
//  Challenge Ladder
//
//  Created by Harry Rollings on 11/08/2020.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import AuthenticationServices
import GoogleSignIn




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Set UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().delegate = self
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        
        
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
        

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

        // Retrieve user ID saved in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
            
            // Check Apple ID credential state
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { [unowned self]
                credentialState, error in
                
                switch(credentialState) {
                case .authorized:
                    break
                case .notFound,
                     .transferred,
                     .revoked:
                    // Perform sign out
                    self.logout()
                    break
                @unknown default:
                    break
                }
            })
        }
        
        // 1
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // 2
        GIDSignIn.sharedInstance().delegate = self
        // 3
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        return true
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {

        return GIDSignIn.sharedInstance().handle(url)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        })
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        //add FCM to fireastore
       
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        let content = response.notification.request.content.userInfo
        let noteType:String = content["type"] as? String ?? ""
        let inLadderID:String = content["ladder"] as? String ?? ""
        print(noteType)
        print(inLadderID)
        
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
               return
           }
           
        
            // instantiate the view controller we want to show from storyboard
            // root view controller is tab bar controller
            // the selected tab is a navigation controller
            // then we push the new view controller to it
            if noteType == "request"{
                //take user to admin request page
                if let navController = rootViewController as? UINavigationController {
                        
                    let ladderref = Firestore.firestore().collection("ladders").document(inLadderID)
                    let pushVC = ViewRequestsViewController()
                    pushVC.setupView(withReference: ladderref)

                    navController.pushViewController(pushVC, animated: true)

                }
                
            }
            else{
                //take user to notification page
                let notificationVC = NotificationViewController()
                if let navController = rootViewController as? UINavigationController {
                        
                        // you can access custom data of the push notification by using userInfo property
                        // response.notification.request.content.userInfo
                        navController.pushViewController(notificationVC, animated: true)
                }
            }
        
           
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           willPresent notification: UNNotification,
           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }
    
    func logout(){
        
        
        let currentUser = Auth.auth().currentUser

        do{
            try Auth.auth().signOut()
            //remove fcm
            
            // Check provider ID to verify that the user has signed in with Apple
               if let providerId = currentUser?.providerData.first?.providerID, providerId == "apple.com" {
                   // Clear saved user ID
                   UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
               }
            
            print(Messaging.messaging().fcmToken!)
            let db = Firestore.firestore()
            db.collection("users").document(MainUser.shared.userID).updateData([
                "fcm": FieldValue.arrayRemove([Messaging.messaging().fcmToken!])
            ])
            UserDefaults.standard.setValue(false, forKey: "usersignedin")
            
        }
        catch _ {
        }

    }
   
   
}


extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            }
            else{
               //successful sign in
                
            }
                
            
        

        }

    }
}

