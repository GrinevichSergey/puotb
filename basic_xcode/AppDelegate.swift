//
//  AppDelegate.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 28/02/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.showModalAuth()
            }
        }

        return true
    }
    
    func showModalAuth() {
    let storybord = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storybord.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        self.window?.rootViewController?.present(newVC, animated: true, completion: nil)
 
    }

}

