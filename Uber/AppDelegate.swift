//
//  AppDelegate.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/13/20.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeController()
        window?.makeKeyAndVisible()
       
        return true
    }

    


}

