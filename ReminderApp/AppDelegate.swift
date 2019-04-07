//
//  AppDelegate.swift
//  ReminderApp
//
//  Created by admin on 2019/03/31.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    fileprivate var reminderData: ReminderData!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let homeController = ReminderViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: homeController)
        window?.rootViewController = navigationController
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    fileprivate var duedateArray = [(text: String, duedate: Date)]()
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        reminderData = ReminderData()
        reminderData.loadData()
        
        // 通知時間を管理する配列の設定
        setupDateArray()
        print(duedateArray)
        
        // 通知の設定
        setupNotification()
    }
    
    func setupNotification() {
        var notificationTime = DateComponents()
        
        for i in 0 ..< duedateArray.count {
            let dueDate = duedateArray[i].duedate
            let components = Calendar.current.dateComponents(in: TimeZone.current, from: dueDate)
            
            notificationTime.year = components.year
            notificationTime.month = components.month
            notificationTime.day = components.day
            notificationTime.hour = components.hour
            notificationTime.minute = components.minute
            
            let identifier: String = String(i)
            
            let content = UNMutableNotificationContent()
            content.title = duedateArray[i].text
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func setupDateArray() {
        for i in 0 ..< reminderData.count() {
            setDateArrayData(reminder: reminderData.data(at: i)!)
        }
    }
    
    func setDateArrayData(reminder: Reminder) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if reminder.duedate != "" {
            let text = reminder.text
            let duedate = formatter.date(from: reminder.duedate)
            duedateArray.append((text: text, duedate: duedate!))
        }
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
