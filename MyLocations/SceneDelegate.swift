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
        
        let tagVC = CurrentLocationViewController()
        let tagNavigationVC = UINavigationController(rootViewController: tagVC)
        tagNavigationVC.tabBarItem.title = "Tag"
        
        let locationsVC = LocationsViewController()
        let locationsNavigationVC = UINavigationController(rootViewController: locationsVC)
        locationsNavigationVC.tabBarItem.title = "Locations"
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([tagNavigationVC, locationsNavigationVC], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
        
        guard let tabBarController = (scene as? UIWindowScene)?.windows.first?.rootViewController as? UITabBarController,
                let navController = tabBarController.viewControllers?.first as? UINavigationController,
              let controller = navController.viewControllers.first as? CurrentLocationViewController else {
            fatalError("Unable to find expected view controllers")
        }
        controller.managedObjectContext = managedObjectContext
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataSaveFailedNotification),
            name: NSNotification.Name("dataSaveFailedNotification"),
            object: nil
        )
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        self.saveContext()
    }
    
    @objc func handleDataSaveFailedNotification() {
        let message = """
There was an error saving your data.
Please contact support at support@example.com and let us know what you were doing when this error occurred.
The app will now close.
"""
        let alert = UIAlertController(title: "Error", message: message,
                                        preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let exception = NSException(name: NSExceptionName.genericException,
                                          reason: "Core Data save failed", userInfo: nil)
            exception.raise()
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyLocations")
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

