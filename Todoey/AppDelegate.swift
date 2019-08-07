//
//  AppDelegate.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/12/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL) //Location of the realm file
        
        
        do {
            _ = try Realm() //underscore because we weren't using the constant realm
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
    
}

