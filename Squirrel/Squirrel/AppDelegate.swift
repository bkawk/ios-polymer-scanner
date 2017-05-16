//
//  AppDelegate.swift
//  Squirrel
//
//  Created by Duc Nguyen on 5/15/17.
//  Copyright © 2017 Squirrel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var webServer:GCDWebServer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // load server local
        startServerController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.stopSever()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.startServer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// server
extension AppDelegate {
    func startServerController() {

        let bundlePath = Bundle.main.resourcePath ?? ""
        let webPath = bundlePath.appendingPathComponent("live")
        
        webServer = GCDWebServer()!
        webServer.addGETHandler(forBasePath: "/", directoryPath: webPath, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        
        webServer.start()
    }
    
    func startServer() {
        webServer.start()
    }
    
    func stopSever() {
        webServer.stop()
    }
}
