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
    
    @Test("getDailyRestingHeartRate")
    func testGetDailyRestingHeartRate() async {
        let model = MockHealthModel()
        await model.requestAuthorization()

        
        let restingHeartRate : Double? = await withCheckedContinuation {continuation in model.getRestingHeartRate {rate in
            continuation.resume(returning: rate)
        }
        }
        #expect(restingHeartRate != nil)
        #expect(restingHeartRate! == 65.0)
        
    }
    
    @Test("getBaselineRHR")
    func testGetBaselineRHR() async {
        let model = MockHealthModel()
        let baselineRHR : Double? = await withCheckedContinuation {continuation in model.getBaselineRHR {baseline in
            continuation.resume(returning: baseline)
        }
        }
        #expect(baselineRHR != nil)
        #expect(baselineRHR! == 60.0)
        
    }
    
    @Test("compare daily rhr with baseline")
    func testCompare() async {
        let model = MockHealthModel()

        let comparison : String? = await withCheckedContinuation {continuation in model.compare {diff in
            continuation.resume(returning: diff)
        }
        }
        #expect(comparison != nil)
        #expect(comparison! == "Elevated")
        
    }
}

