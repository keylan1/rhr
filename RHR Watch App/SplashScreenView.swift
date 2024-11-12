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
            Image(systemName: "heart")
            Text("DRHR App").bold().font(.title2).padding(15)
            Spacer()
            ProgressView().accessibilityIdentifier("LoadingIndicator").scaleEffect(1.75)
        }
    }
}

#Preview {
    SplashScreenView()
}
