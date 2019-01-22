//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Andre Sanches Bocato on 11/01/19.
//  Copyright © 2019 Andre Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    // MARK: - Properties

    static let shared = NotificationManager()
    var notificationIds = [String]()
    var taskManager: TaskManager!
    // MARK: - Functions

    func sendPushNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "It's time for \(task.name)!"
        content.body = task.description
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let notificationId = task.id
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        UNUserNotificationCenter.current().delegate = self
    }
    
    func removePushNotification(notificationId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

// MARK: - Extensions

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        TaskManager.shared.setTaskAsCompleted(response.notification.request.identifier , isCompleted: true)
        completionHandler()
    }
    
}

