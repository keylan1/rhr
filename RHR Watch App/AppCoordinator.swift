//
//  AppCoordinator.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import SwiftUI

struct AppCoordinator: View {
    //Change to HealthModel() when no longer mocking data
    @StateObject private var healthModel = MockHealthModel()
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreenView()
            } else if healthModel.isAuthorized {
                AppInterface()
            } else {
                Text("HealthKit authorization not granted. Check settings.")
            }
        }
        .task {
            await healthModel.requestAuthorization()
            try? await Task.sleep(for: .seconds(2))
            
            withAnimation {
                isShowingSplash = false
            }
        }
    }
}

#Preview {
    AppCoordinator()
}