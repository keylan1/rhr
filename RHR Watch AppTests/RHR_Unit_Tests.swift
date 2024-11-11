//
//  AppCoordinator.swift
//  RHR Watch AppTests
//
//  Created by Sarah Keller on 11.11.24.
//

import Testing
import Foundation
@testable import RHR_Watch_App

@Suite("MockHealthModelTests")
struct MockHealthModelTests {
    @Test("Initial state is unauthorized")
    func testInitialState() {
        let model = MockHealthModel()
        #expect(model.isAuthorized == false)
    }

    @Test("Authorization becomes true after request")
    func testRequestAuthorization() async {
        let model = MockHealthModel()
        await model.requestAuthorization()
        
        // Wait for the simulated delay
        try? await Task.sleep(for: .seconds(2.1))
        
        #expect(model.isAuthorized == true)
    }
}

