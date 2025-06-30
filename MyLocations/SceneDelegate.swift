//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Валерий Новиков on 25.06.25.
//

import UIKit
import CoreData

struct SceneDelegateValues {
    static let tagTitle = "Tag"
    static let locationTitle = "Locations"
    static let mapTitle = "Map"
    
    static let dataSaveFailedNotification = "dataSaveFailedNotification"
    
    static let dataSaveFailedMessage = """
There was an error saving your data.
Please contact support at support@example.com and let us know what you were doing when this error occurred.
The app will now close.
"""
    static let dataSaveFailedReason = "Core Data save failed"
    
    static let alertTitleText = "Error"
    static let alertActionText = "OK"
    
    static let containerName = "MyLocations"
}

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
        tagNavigationVC.tabBarItem.title = SceneDelegateValues.tagTitle
        
        let locationsVC = LocationsViewController()
        let locationsNavigationVC = UINavigationController(rootViewController: locationsVC)
        locationsNavigationVC.tabBarItem.title = SceneDelegateValues.locationTitle
        
        let mapVC = MapViewController()
        let mapNavigationVC = UINavigationController(rootViewController: mapVC)
        mapNavigationVC.tabBarItem.title = SceneDelegateValues.mapTitle
        
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
            name: NSNotification.Name(SceneDelegateValues.dataSaveFailedNotification),
            object: nil
        )
    }
    
    @objc func handleDataSaveFailedNotification() {
        let message = SceneDelegateValues.dataSaveFailedMessage
        let alert = UIAlertController(title: SceneDelegateValues.alertTitleText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: SceneDelegateValues.alertActionText, style: .default, handler: { _ in
            let exception = NSException(name: NSExceptionName.genericException, reason: SceneDelegateValues.dataSaveFailedReason, userInfo: nil)
            exception.raise()
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: SceneDelegateValues.containerName)
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

