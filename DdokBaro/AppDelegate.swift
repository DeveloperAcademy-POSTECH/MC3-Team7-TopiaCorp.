//
//  AppDelegate.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/11.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        print("launchedBefore: \(launchedBefore)")
//        if !launchedBefore {
//            print("First launch - displaying onboarding views")
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//            print("launchedBefore set to true")
//            let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
//            let noAirpodViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "NoAirpodViewController")
//            let onboarding1ViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "Onboarding1ViewController")
//            let onboarding3ViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "Onboarding3ViewController")
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let zeroPointViewController = mainStoryboard.instantiateViewController(withIdentifier: "ZeroPointViewController")
//            
//            let navigationController = UINavigationController(rootViewController: noAirpodViewController)
//            navigationController.pushViewController(onboarding1ViewController, animated: true)
//            navigationController.pushViewController(onboarding3ViewController, animated: true)
//            navigationController.pushViewController(zeroPointViewController, animated: true)
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first {
//                window.rootViewController = navigationController
//                window.makeKeyAndVisible()
//            }
//        } else {
//            print("App already launched before - displaying main view")
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first {
//                window.rootViewController = welcomeViewController
//                window.makeKeyAndVisible()
//            }
//        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this with proper error handling
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// Add UNUserNotificationCenterDelegate conformance (if not already added) to handle notifications
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    // Add the required delegate methods here (optional, depending on your notification handling needs)
//}
//이 변경으로 'window' 속성에 액세스할 수 있어야 하며 코드가 예상대로 작동해야 합니다. UIApplication.shared.windows.first는 기본 창에 대한 액세스를 제공하며 이에 따라 루트 뷰 컨트롤러를 설정할 수 있습니다.




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

    // MARK: - Core Data stack

var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "DdokBaro")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list,.sound,.banner])
    }

}
