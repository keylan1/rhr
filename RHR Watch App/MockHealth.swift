//
//  MockHealth.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

//Wont trigger notifications on the physical watch if mocking.

import Foundation
import UserNotifications

class MockHealthModel: HealthModelProtocol {
    @Published var isAuthorized = false
    var notificationManager = MockNotificationManager()
    
    func requestAuthorization() async {
        // Simulate a delay
        try? await Task.sleep(for: .seconds(2))
        
        // Simulate successful authorization
        DispatchQueue.main.async {
            self.isAuthorized = true
        }
    }

        func getRestingHeartRate(completion: @escaping (Double?) -> Void) {
            // Mock daily RHR (e.g., 65 bpm)
            completion(65.0)
        }

        func getBaselineRHR(completion: @escaping (Double?) -> Void) {
            // Mock baseline RHR (e.g., 60 bpm)
            completion(57.0)
        }

    func compare(completion: @escaping(String?) -> Void) {
        getRestingHeartRate {result in
            if let restingHeartRate = result {
                self.getBaselineRHR {baseline in
                    if let baselineRHR = baseline {
                        let diff = restingHeartRate - baselineRHR
                        let toCompare = 0.1 * baselineRHR
                        if diff >= toCompare {
                            Task {
                                await self.notificationManager.illNotification()
                            }
                            completion("Elevated")
                        } else {
                            Task {
                                await self.notificationManager.normalNotification()
                            }
                            completion("Normal")
                        }
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}

class MockNotificationManager: NSObject, ObservableObject {
    @Published var isNotificationAuthorized = false
    let notificationCenter = UNUserNotificationCenter.current()
    func requestNotificationAuth() async {
        isNotificationAuthorized = true
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
