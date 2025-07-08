//
//  AppDelegate.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import UIKit
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let plist = Bundle.main.path(forResource: .google)
        let clientId = plist[Constants.clientId.rawValue] as? String ?? .empty

        GIDSignIn.sharedInstance.configuration = .init(clientID: clientId)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {

        let plist = Bundle.main.path(forResource: .google)
        let clientId = plist[Constants.clientId.rawValue] as? String ?? .empty

        GIDSignIn.sharedInstance.configuration = .init(clientID: clientId)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Handle background tasks here
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }

          // Handle other custom URL types.

          // If not handled by this app, return false.
          return false
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Returning a default configuration for the new scene
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate {
    enum Constants: String {
        case clientId = "CLIENT_ID"
        case reversedClientId = "REVERSED_CLIENT_ID"
    }
}
