//
//  DegenSplashScreenView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/25/25.
//

import Foundation
import SwiftUI

// Create a separate Degen Splash Screen View
struct DegenSplashScreen: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
            
            VStack {
                Text("DEGEN MODE")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.red)
                
                Text("Win big.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}
