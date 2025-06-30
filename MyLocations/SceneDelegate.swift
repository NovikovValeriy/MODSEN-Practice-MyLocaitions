//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Валерий Новиков on 25.06.25.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = tabBarControllerSetup()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
        
        coreDataContextSetup(tabBarController)
        
        notificationObserverSetup()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        self.saveContext()
    }
    
    private func tabBarControllerSetup() -> UITabBarController {
        let tagVC = CurrentLocationViewController()
        let tagNavigationVC = UINavigationController(rootViewController: tagVC)
        tagNavigationVC.tabBarItem.title = "Tag"
        
        let locationsVC = LocationsViewController()
        let locationsNavigationVC = UINavigationController(rootViewController: locationsVC)
        locationsNavigationVC.tabBarItem.title = "Locations"
        
        let mapVC = MapViewController()
        let mapNavigationVC = UINavigationController(rootViewController: mapVC)
        mapNavigationVC.tabBarItem.title = "Map"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([tagNavigationVC, locationsNavigationVC, mapNavigationVC], animated: false)
        return tabBarController
    }
    
    private func coreDataContextSetup(_ tabBarController: UITabBarController) {
        guard let tabBarViewControllers = tabBarController.viewControllers else { return }
        
        var navController = tabBarViewControllers[0] as! UINavigationController
        let controller1 = navController.topViewController as! CurrentLocationViewController
        controller1.managedObjectContext = managedObjectContext
        
        navController = tabBarViewControllers[1] as! UINavigationController
        let controller2 = navController.topViewController as! LocationsViewController
        controller2.managedObjectContext = managedObjectContext
        
        navController = tabBarViewControllers[2] as! UINavigationController
        let controller3 = navController.topViewController as! MapViewController
        controller3.managedObjectContext = managedObjectContext
    }
    
    private func notificationObserverSetup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataSaveFailedNotification),
            name: NSNotification.Name("dataSaveFailedNotification"),
            object: nil
        )
    }
    
    @objc func handleDataSaveFailedNotification() {
        let message = """
There was an error saving your data.
Please contact support at support@example.com and let us know what you were doing when this error occurred.
The app will now close.
"""
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let exception = NSException(name: NSExceptionName.genericException, reason: "Core Data save failed", userInfo: nil)
            exception.raise()
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLocations")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

