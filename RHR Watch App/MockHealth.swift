//
//  MockHealth.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import Foundation
import UserNotifications

class MockHealthModel: HealthModelProtocol {
    @Published var isAuthorized = false
    
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
            completion(60.0)
        }

        func compare(completion: @escaping (String?) -> Void) {
            // Mock comparison result (e.g., "Elevated" or "Normal")
            completion("Elevated")
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
}
