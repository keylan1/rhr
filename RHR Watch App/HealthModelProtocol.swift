//
//  HealthModelProtocol.swift
//  RHR Watch AppTests
//
//  Created by Sarah Keller on 04.11.24.
//

import Foundation

//Protocol for mocking/testing data to simulate successful auth

public protocol HealthModelProtocol: ObservableObject {
    var isAuthorized: Bool { get set }
    func requestAuthorization() async
}
