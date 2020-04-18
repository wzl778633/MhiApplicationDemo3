//
//  AppDelegate.swift
//  CustomLoginDemo
//
//  Created by wang songtao on 2/28/20.
//  Copyright © 2020 wang songtao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let chatServerConfig = ChatServiceConfig()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let config = ChatUIConfiguration()
        config.configureUI()

        let serverConfig = ChatServerConfiguration()

        if (serverConfig.isFirebaseAuthEnabled || serverConfig.isFirebaseDatabaseEnabled) {
            FirebaseApp.configure()
        }

        let threadsDataSource = ATCChatFirebaseChannelDataSource()
        let userSearchDataSource: ATCGenericSearchViewControllerDataSource = (serverConfig.isFirebaseDatabaseEnabled ?
            ATCFirebaseFriendsSearchDataSource() :
            ATCGenericLocalSearchDataSource(items: ATCChatMockStore.users))

        let profileManager: ATCProfileManager? = (serverConfig.isFirebaseDatabaseEnabled ? ATCFirebaseProfileManager() : nil)
        let reportingManager: ATCUserReportingProtocol? = (serverConfig.isFirebaseDatabaseEnabled ? ATCFirebaseUserReporter() : nil)

        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ChatHostViewController(uiConfig: config,
                                                            serverConfig: serverConfig,
                                                            chatServiceConfig: chatServerConfig,
                                                            threadsDataSource: threadsDataSource,
                                                            profileManager: profileManager,
                                                            userSearchDataSource: userSearchDataSource,
                                                            reportingManager: reportingManager)
        window?.makeKeyAndVisible()
        

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

