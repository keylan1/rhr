//
//  RHRApp.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 14.10.24.
//

import SwiftUI

@main
struct RHR_Watch_AppApp: App {
    @State private var newItemTitle = ""
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
