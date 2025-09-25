//
//  DojoApp.swift
//  Dojo
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import FirebaseCore

@main
struct DojoApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                ContentView()
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
