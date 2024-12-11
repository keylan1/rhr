//
//  AppInterface.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import SwiftUI

struct AppInterface: View {
    @ObservedObject var healthModel: MockHealthModel
    @State private var dailyRestingHeartRate: Double?
    @State private var status: String?
    //@State private var counter: Int = 0
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            VStack {
                    Text("Welcome!").font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Your dRHR Stats ").font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                
            }
            Spacer()
            Text("Daily RHR: \(dailyRestingHeartRate?.formatted(.number) ?? "--"        )").accessibilityIdentifier("DailyRHRLabel")
            Text("Status: \(status ?? "--")").accessibilityIdentifier("StatusLabel").foregroundColor(status == "Normal" ? Color.green : (status == "Elevated" ? Color.yellow : Color.red))
            //Text("Counter: \(counter)").accessibilityIdentifier("CounterLabel") .foregroundColor(Color.gray.opacity(0.7))
        }
        .onAppear{fetchHeartRate()
            fetchStatus()}
    }
    private func fetchHeartRate() {
        healthModel.getRestingHeartRate { rate in
            DispatchQueue.main.async {
                self.dailyRestingHeartRate = rate
            }
        }
    }
    private func fetchStatus() {
        healthModel.compare {result in
            DispatchQueue.main.async {
                self.status =  result
            }}
    }
}

#Preview {
    AppInterface(healthModel: MockHealthModel())
}
