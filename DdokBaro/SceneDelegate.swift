//
//  SceneDelegate.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        setRootViewController(scene)
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}
extension SceneDelegate {
    private func setRootViewController(_ scene: UIScene){
        if Storage.isFirstTime() {
            print("첫 번째 실행")
            setOnboardingViewController(scene)
        } else {
            print("두 번째 이후 실행")
            setMainViewController(scene)
        }
    }
    
    private func setOnboardingViewController(_ scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let noAirpodViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "NoAirpodViewController")
            let onboarding1ViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "Onboarding1ViewController")
            let onboarding3ViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "Onboarding3ViewController")
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let zeroPointViewController = mainStoryboard.instantiateViewController(withIdentifier: "ZeroPointViewController")
            
            let navigationController = UINavigationController(rootViewController: noAirpodViewController)
            
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
            
        }
    }
    private func setMainViewController(_ scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}


