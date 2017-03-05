//
//  AppDelegate.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingDelegate {

    var window: UIWindow?

    let auth = SPTAuth.defaultInstance()
    let player = SPTAudioStreamingController.sharedInstance()
    var authViewController:UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let secrets = getSecrets()
        
        auth?.clientID = secrets.0
        auth?.redirectURL = URL(string: secrets.1)
        auth?.sessionUserDefaultsKey = "current session"
        auth?.requestedScopes = [SPTAuthStreamingScope]
        
        player?.delegate = self
        
        do {
            try player?.start(withClientId: auth?.clientID)
        } catch {
            print("start error")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.startAuthenticationFlow()
        }
        
        return true
    }
    
    private func startAuthenticationFlow(){
        if(/*auth?.session.isValid() ??*/ false){
            startLoginFlow()
        } else {
            let authURL = auth?.spotifyWebAuthenticationURL()
            authViewController = SFSafariViewController(url: authURL!)
            window?.rootViewController?.present(authViewController!, animated: true, completion: nil)
        }
    }

    private func startLoginFlow(){
        
    }
    
    private func getSecrets() -> (String, String) {
        if let fileUrl = Bundle.main.url(forResource: "secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                guard let clientID = result?["clientID"] as? String else {
                    print("clientID not found in secrets")
                    return ("", "")
                }
                
                guard let redirectURL = result?["redirectURL"] as? String else {
                    print("redirectURL not found in secrets")
                    return ("", "")
                }
                
                return (clientID, redirectURL)
            }
        }
        
        print("secrets.plist not found.")
        return ("", "")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        window?.rootViewController?.performSegue(withIdentifier: "toTabViewController", sender: nil)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if(auth?.canHandle(url) ?? false){
            authViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            authViewController = nil
            
            auth?.handleAuthCallback(withTriggeredAuthURL: url, callback: {[weak self] (error, session) in
                if(session != nil) {
                    self?.player?.login(withAccessToken: self?.auth?.session.accessToken)
                }
            })
            return true
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

