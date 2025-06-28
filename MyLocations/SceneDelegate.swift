//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Валерий Новиков on 25.06.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let rootVC = CurrentLocationViewController()
        let rootNavigationVC = UINavigationController(rootViewController: rootVC)
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([rootNavigationVC], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }


}

