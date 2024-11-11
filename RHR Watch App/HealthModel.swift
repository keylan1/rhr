//
//  HealthModel.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 23.10.24.
//

import Foundation
import HealthKit

class HealthModel: HealthModelProtocol {
    let healthStore = HKHealthStore()
    @Published var isAuthorized = false
    
    // Request authorization to access HealthKit.
    func requestAuthorization() async {
        // The quantity type to read from the health store.
        let rhr = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        // Request authorization for those quantity types. in a do catch and not try? await because you want the error
        do {
            try await
            healthStore.requestAuthorization(toShare: [], read: [rhr])
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("Healthkit authorization failed \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
}

