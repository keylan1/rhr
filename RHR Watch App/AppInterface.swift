//
//  AppInterface.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import SwiftUI

struct AppInterface: View {
    @State private var dailyRestingHeartRate: Int = 0
        @State private var status: String = "Normal"
        @State private var counter: Int = 0
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            HStack {
                Text("RHR Stats").font(.title2)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
            }
            Spacer()
            Text("Daily RHR: \(dailyRestingHeartRate)").accessibilityIdentifier("DailyRHRLabel")
            Text("Status: \(status)").accessibilityIdentifier("StatusLabel").foregroundColor(status == "Normal" ? Color.green : (status == "Elevated" ? Color.yellow : Color.red))
            Text("Counter: \(counter)").accessibilityIdentifier("CounterLabel") .foregroundColor(Color.gray.opacity(0.7))
        }
    }
}

#Preview {
    AppInterface()
}
