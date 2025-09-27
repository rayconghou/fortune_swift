//
//  DojoApp.swift
//  Dojo
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import FirebaseCore
import CoreText

@main
struct DojoApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
        registerCustomFonts()
    }
    
    private func registerCustomFonts() {
        // Register The Last Shuriken font
        if let fontURL = Bundle.main.url(forResource: "The Last Shuriken", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
        
        // Register Satoshi fonts - all variants we're using
        let satoshiFonts = [
            "Satoshi-Black", "Satoshi-BlackItalic", 
            "Satoshi-Bold", "Satoshi-BoldItalic",
            "Satoshi-Medium", "Satoshi-MediumItalic",
            "Satoshi-Regular", "Satoshi-Italic",
            "Satoshi-Light", "Satoshi-LightItalic"
        ]
        for fontName in satoshiFonts {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
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
