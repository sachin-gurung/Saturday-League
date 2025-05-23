//
//  Saturday_LeagueApp.swift
//  Saturday League
//
//  Created by Sachin Gurung on 6/17/24.
//

import SwiftUI
import FirebaseCore

@main
struct Saturday_LeagueApp: App {
    //Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
