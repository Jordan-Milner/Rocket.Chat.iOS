//
//  AppDelegate.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/5/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import Pendo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationWindow: TransparentToTouchesWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Launcher().prepareToLaunch(with: launchOptions)

        PushManager.setupNotificationCenter()
        application.registerForRemoteNotifications()

        if let launchOptions = launchOptions,
           let notification = launchOptions[.remoteNotification] as? [AnyHashable: Any] {
            PushManager.handleNotification(raw: notification)
        }

        // If user is authenticated, open the chat right away
        // but if not, just open the authentication screen.
        if let auth = AuthManager.isAuthenticated() {
            AuthManager.persistAuthInformation(auth)
            AuthSettingsManager.shared.updateCachedSettings()
            WindowManager.open(.subscriptions)
        } else {
            if AppManager.supportsMultiServer {
                WindowManager.open(.auth(serverUrl: "", credentials: nil))
            } else {
                WindowManager.open(.auth(serverUrl: "", credentials: nil), viewControllerIdentifier: "ConnectServerNav")
            }
        }
        
        let initParams = PendoInitParams()
        initParams.visitorId = "John Smith"
        initParams.visitorData = ["Age": "27", "Country": "USA", "Gender": "Male"]
        initParams.accountId = "Acme"
        initParams.accountData = ["Tier": "1", "Timezone": "EST", "Size": "Enterprise"]
        
        
        PendoManager.shared().initSDK(
            "eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiI0YzZhMGU5NWQwNjI0YjA4ZjYxZGRlY2RhNmM1ZjczNTYyODRmMzZlYTdlOGJmYzExYTU2Zjc5OWE0MGI1MmY1MDQ4Y2UwMWRkMWQ2OWY4N2FjNzNmODNkYWFjODVlNWZlY2EzYTA2ZTI5ZDMzZTMzNzU3NTRlYjE4ODc0YjA1YS42MGMxMzkxNTM3ODA3MDIxYWNmOTg3YmRhN2I2NzFlMC40MjI2M2RhNGJjMjMxZjNmZGU3MmUwMjI4NGM3ZTYxMzk2OTE1MDg3M2JhZThhOGZiY2IwMzI2ZmQ5MTEzY2VhIn0.U0oFTIlAQBUiofP4KUpPSXDCHHD38zGsgviOyTiTg-VIts899aI_yQ8_9rAw1x6dfZ64JpkJzR9GVNryTrk_47QOjjgtg-YMqy7WvHzAp1sgwXKgQb1rR5UP7ECNzggO7TYu8Z-2bXhjkPnULhDh3_Rszg9f4kn64sBV7XvJdcw",
            initParams: initParams) // call initSDK with initParams as a 2nd parameter.

        initNotificationWindow()

        return true
    }
    
    func initNotificationWindow() {
        notificationWindow = TransparentToTouchesWindow(frame: UIScreen.main.bounds)
        notificationWindow?.rootViewController = NotificationViewController.shared
        notificationWindow?.windowLevel = UIWindow.Level.alert
        notificationWindow?.makeKeyAndVisible()
        notificationWindow?.isHidden = true
    }

    // MARK: AppDelegate LifeCycle

    func applicationDidBecomeActive(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()

        if AuthManager.isAuthenticated() != nil {
            if !SocketManager.isConnected() && !(AppManager.isOnAuthFlow) {
                SocketManager.reconnect()
            }
        }

        ShortcutsManager.sync()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SubscriptionManager.updateUnreadApplicationBadge()
        ShortcutsManager.sync()

        if AuthManager.isAuthenticated() != nil {
            UserManager.setUserPresence(status: .away) { (_) in
                SocketManager.disconnect({ (_, _) in })
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SubscriptionManager.updateUnreadApplicationBadge()
        ShortcutsManager.sync()
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL, AppManager.handleDeepLink(url) != nil {
            return true
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            
            return true
        }
        if AppManager.handleDeepLink(url) != nil {
            return true
        }

        return false
    }

    // MARK: Remote Notification

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.group.set(deviceToken.hexString, forKey: PushManager.kDeviceTokenKey)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.debug("Fail to register for notification: \(error)")
    }

    // MARK: Shortcuts

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let userInfo = shortcutItem.userInfo {
            if let index = userInfo[ShortcutsManager.serverIndexKey] as? Int {
                AppManager.changeSelectedServer(index: index)
            } else if let roomId = userInfo[ShortcutsManager.roomIdKey] as? String,
                let serverURL = userInfo[ShortcutsManager.serverUrlKey] as? String {
                AppManager.changeToRoom(roomId, on: serverURL)
            } else {
                completionHandler(false)
            }

            completionHandler(true)
        } else if shortcutItem.type == ShortcutsManager.addServerActionIdentifier, AuthManager.isAuthenticated() != nil {
            WindowManager.open(
                .auth(
                    serverUrl: "",
                    credentials: nil
                ), viewControllerIdentifier: ShortcutsManager.connectServerNavIdentifier
            )

            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
}
