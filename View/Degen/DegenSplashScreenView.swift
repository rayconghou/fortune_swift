//
//  DegenSplashScreenView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/25/25.
//

import Foundation
import SwiftUI

struct DegenSplashScreen: View {
    @State private var showFortune = false
    @State private var showBottomElements = false
    
    var body: some View {
        ZStack {
            // Futuristic dark background
            LinearGradient(
                gradient: Gradient(colors: [
                    .black,
                    .black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("DEGEN")
                        .font(.system(size: 56, weight: .black))
                        .foregroundColor(.white)
                        .opacity(showFortune ? 1 : 0)
                        .animation(.easeInOut(duration: 0.4).delay(0.2), value: showFortune)
                    
                    Text("MODE")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.cyan)
                        .opacity(showFortune ? 1 : 0)
                        .animation(.easeInOut(duration: 0.4).delay(0.3), value: showFortune)
                }
                
                VStack {
                    Divider()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.7), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 250, height: 2)
                        .opacity(showBottomElements ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: showBottomElements)
                    
                    Image("SplashScreenBranding") // Replace with your specific logo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .opacity(showBottomElements ? 1 : 0)
                        .scaleEffect(showBottomElements ? 1 : 0.8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.3).delay(0.5), value: showBottomElements)
                }
            }
        }
        .onAppear {
            // Trigger animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showFortune = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showBottomElements = true
            }
        }
    } 
}
