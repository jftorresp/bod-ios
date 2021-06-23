//
//  AppDelegate.swift
//  catpay-ios
//
//  Created by Francisco Vasquez on 6/7/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    static var balance:Double = 0.0
    static var status = ""
    static var bankAccounts:[banksModel] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()!
        let navigationVC = PrincipalNavigationViewController(rootViewController: initialViewController)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        UserDefaults.standard.set(true, forKey: "addUser") // like so        
        
        //integrate fabric
        
        Fabric.with([Crashlytics.self, Answers.self])
        
        
        // verify connection with host
        
        
        Task.Check { (_) in
            
            
        }
        
        
        return true
    }
    
    
    // fetch and update Config
    func forceUpdate() {
        
        let fetchDuration: TimeInterval = 0
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration:fetchDuration) { (status, error) in
            guard error == nil else {
                //handle error here
                return
            }
           
            let rc = RemoteConfig.remoteConfig()
            RemoteConfig.remoteConfig().activateFetched()
            let cloudBuild =  rc.configValue(forKey: "build_demo_ios_current_version").numberValue as! Int
            
            let myBuild = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
        
            
            if myBuild! < cloudBuild{
                
                let url = URL(string: "https://www.apple.com/lae/ios/app-store")!
                let title = NSLocalizedString("notification.ForceUpdateTitle", comment: "")
                let msg = NSLocalizedString("notification.forceUpdateMessage", comment: "")
                let button = NSLocalizedString("notification.forceUpdateButton", comment: "")
                let alert = UIAlertController(title: title, message: msg, preferredStyle:UIAlertControllerStyle.alert)
                
                // creando notificacion
                alert.addAction(UIAlertAction(title:button,style:UIAlertActionStyle.default,handler:{(action) in
                    
                    
                    if #available(iOS 10.0, *) {
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: { (_) in exit(0) })
                        
                    } else {
                        
                        UIApplication.shared.openURL(url)
                    
                    }}))
             
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }}
 
    }
    
    // push notification
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //When the notifications of this code worked well, there was not yet.
        Messaging.messaging().apnsToken = deviceToken
       // let x = Messaging.messaging().fcmToken
       // print(x!)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
    
        
        print(remoteMessage.appData)
    
    
    }
    
    
    func switchControllers(viewControllerToBeDismissed:UIViewController,controllerToBePresented:UIViewController) {
        if (viewControllerToBeDismissed.isViewLoaded && (viewControllerToBeDismissed.view.window != nil)) {
            // viewControllerToBeDismissed is visible
            //First dismiss and then load your new presented controller
            
        //    let topView = UtilityMethods.getTopViewController()
            
            if let parent = viewControllerToBeDismissed.presentingViewController{
                
                viewControllerToBeDismissed.dismiss(animated: false, completion: {
                    parent.present(controllerToBePresented, animated: true, completion: nil)
                    
                })
             return   
            }
            
            viewControllerToBeDismissed.dismiss(animated: false, completion: {
                self.window?.rootViewController?.present(controllerToBePresented, animated: true, completion: nil)
            })
            
          
        }
    }
    
    
    func setRootInitialView(){
    
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
        
        self.window?.rootViewController =         PrincipalNavigationViewController(rootViewController: initialViewController)

        UIView.animate(withDuration: 0.75) {
            self.window?.makeKeyAndVisible()
        }
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
       if OAuthManager.shared.sessionAlive{

            Task.paymentHistory(refreshed: false, page: 1, pageSize: 1, completion: { (_) in
                
            })
            
        
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb{
            
            let url = userActivity.webpageURL!
            let path = url.path
            
            if path.lowercased().contains("forgot_password"){
                
            
                let queryString =  url.query
                let queryUsername = url.pathComponents[3]
           
                let queryToken = queryString?.components(separatedBy: "=")[1]
                
                let storyboard = UIStoryboard(name: "RecoveryPassword", bundle: nil)
                
                let recoveryPassword = storyboard.instantiateViewController(withIdentifier: "RecoveryPassword") as! RecoveryPasswordViewController
                
                recoveryPassword.token = queryToken!
                recoveryPassword.username = queryUsername
                
                self.window?.rootViewController = recoveryPassword
                self.window?.makeKeyAndVisible()
                
                
            }
            
    }
        return true
    }
    
    
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}

