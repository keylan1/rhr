//
//  MockHealth.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import Foundation

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
}
