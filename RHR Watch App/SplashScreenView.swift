//
//  SplashScreenView.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 04.11.24.
//

import SwiftUI

struct SplashScreenView: View {

    var body: some View {
        VStack {
            Image("drhr_appicon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            Text("dRHR").bold().font(.title2).padding(10)
            Spacer()
            ProgressView().accessibilityIdentifier("LoadingIndicator").scaleEffect(1.75)
        }
    }
}

#Preview {
    SplashScreenView()
}
