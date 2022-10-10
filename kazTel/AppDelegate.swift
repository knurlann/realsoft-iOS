//
//  AppDelegate.swift
//  kazTel
//
//  Created by Нурлан on 01.06.2018.
//  Copyright © 2018 Нурлан. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import Locksmith



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate  {
    var badge = "0"
    var window: UIWindow?
    let gcmMessageIDKey = "mail"
//    var messageLink = ""

    let userDefaults = UserDefaults.standard
    struct defaultsKeys {
        static let keyOne = "deviceToken"
        static let keyTwo = "no"
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
     
    
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }

        
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        application.registerForRemoteNotifications()

        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
        
        
        
        
        if userDefaults.bool(forKey: "onboardingComplete") {
            initialViewController = sb.instantiateViewController(withIdentifier: "Mainapp")
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if error != nil {
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        
       
      
        
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
 

        updateUserInterface()
        
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        print("token: \(token)")

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            Ims.messageLink = messageID as! String
        }
        
        // Print full message.
        print(userInfo)
    }
    // This method is called when user CLICKED on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        // Do whatever you want when the user tapped on a notification
        // If you are waiting for a specific value from notification
        // (e.g., associated with key "valueKey"),
        // you can capture it as follows then do the navigation:

        
        coordinateToSomeVC()
    
        
        completionHandler()
    }


    
    private func coordinateToSomeVC()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "Mainapp") as! UITabBarController

        tabBarController.selectedIndex = 2
        tabBarController.selectedViewController = tabBarController.viewControllers![1]
        tabBarController.navigationController?.pushViewController(tabBarController.selectedViewController!, animated: true)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
//        self.window?.makeKeyAndVisible()
        
        
        
        
    }
    func moveToNextViewController() {
        //Add code for present or push view controller
               let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"Mainapp") as! UITabBarController
        vc.selectedViewController = vc.viewControllers![1]
//              vc.pushViewController(vc, animated: true)
        }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if userDefaults.string(forKey: defaultsKeys.keyOne) != fcmToken{
            userDefaults.set(fcmToken, forKey: defaultsKeys.keyOne)
            userDefaults.set("no", forKey: defaultsKeys.keyTwo)
        }
        
        
        
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        getBadgeCount()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
            application.applicationIconBadgeNumber = Int(badge)!
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        getBadgeCount()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
        application.applicationIconBadgeNumber = Int(badge)!
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        
        getBadgeCount()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
            application.applicationIconBadgeNumber = Int(badge)!
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "kazTel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    

    // MARK: - Core Data Saving support
    func updateUserInterface() {
        window = UIWindow(frame: UIScreen.main.bounds)
        var sb = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController = sb.instantiateViewController(withIdentifier: "Mainapp")

        if userDefaults.bool(forKey: "onboardingComplete") {
            initialViewController = sb.instantiateViewController(withIdentifier: "Mainapp")
        }else{
            initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
        }
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
 
        
        
       
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getBadgeCount() {
        let semaphore = DispatchSemaphore (value: 0)
        guard let adresPush = userDefaults.string(forKey: "section") else { return }
        guard let url = URL(string: adresPush) else { return }
        

        
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast"){
            var username = dictionary["login"] as! String
            let password = (dictionary["password"])! as! String
            let loginString = "\(username):\(password)"
            if username.contains(" "){
                username =  username.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)            }
            
            var request = URLRequest(url: URL(string: "\(url)/SKYDOCS/skydocs_connector.nsf/badge.xsp/LoadBadge?username=\(username)")!,timeoutInterval: Double.infinity)

            
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                return
            }
            let base64LoginString = loginData.base64EncodedString()

            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            

            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
                guard let a = self.convertStringToDictionary(text: (String(data: data, encoding: .utf8)!)) else { return } 
                self.badge = a["info"]! as! String
                
              semaphore.signal()
            }

            task.resume()
            semaphore.wait()
            
           
        }else{
            print("no keys")
        }
       
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    


}

