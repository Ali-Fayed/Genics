//
//  AppDelegate.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//
import UIKit
import CoreData
import XCoordinator
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window: UIWindow! = UIWindow()
    let router = AppCoordinator().strongRouter
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        printDirectory()
        networkReachability()
        keyboardConfiguration()
        appRouting()
        return true
    }
    //MARK: - App Domain Directory
    func printDirectory () {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
    }
    //MARK: - Network Reachability
    func networkReachability () {
        GitNetworkMonitor.shared.startMonitoring()
        GitNetwrokReachability.shared.startNetworkMonitoring()
    }
    //MARK: - Keyboard Configuration
    func keyboardConfiguration () {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    //MARK: - App route
    func appRouting () {
        window?.overrideUserInterfaceStyle = .dark
        router.setRoot(for: window)
    }
    // MARK: -  UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Githubgenics")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
