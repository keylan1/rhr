//
//  NotificationManager.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 13.11.24.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject {
    @Published var isNotificationAuthorized: Bool = false
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuth() async {
        do {
            try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            isNotificationAuthorized = true
        } catch {
            //Error msg
            print("Notification authorization not granted")
            isNotificationAuthorized = false
        }
    }
    
    func checkNotificationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized:
            isNotificationAuthorized = true
        case .denied, .notDetermined:
            await requestNotificationAuth()
        case .provisional:
            await requestNotificationAuth()
        @unknown default:
            await requestNotificationAuth()
        }
    }
    
    func illNotification() async {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = NSString.localizedUserNotificationString(forKey: "Elevated", arguments: nil)
        notificationContent.body = NSString.localizedUserNotificationString(forKey: "Elevated", arguments: nil)
        notificationContent.sound = UNNotificationSound.default
        let notificationIdentifier = "elevated"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func normalNotification() async {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = NSString.localizedUserNotificationString(forKey: "Normal", arguments: nil)
        notificationContent.body = NSString.localizedUserNotificationString(forKey: "Normal", arguments: nil)
        notificationContent.sound = UNNotificationSound.default
        let notificationIdentifier = "normal"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
//Request auth

//Check notification status

//Notification format and trigger

//Trigger based on status

//Create separate views to model notification and different statuses
//Figure out how end to end testing with real data will work on the watch
//Mock via tests and screen recording
