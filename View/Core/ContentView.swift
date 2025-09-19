//
//  ContentView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import Combine
import FirebaseAuth

import AWSSQS

// MARK: - Main ContentView with Splash Screen

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var hideSplash = false
    @State private var showFortune = false
    @State private var showCollective = false
    @State private var showBottomElements = false
    @State private var isSignedIn = false
    @StateObject static var securityViewModel = SecureSignInFlowViewModel()
    
    var body: some View {
        ZStack {
            Group {
//                Change to: if authView.SOMETHING
                if authViewModel.isLoggedIn {
                    SecureSignInFlowView()
                        .environmentObject(ContentView.securityViewModel)
                } else {
                    AuthView()
                }
            }
            .zIndex(0)
            
            splashScreen
                .offset(y: hideSplash ? -UIScreen.main.bounds.height : 0)
                .animation(.easeInOut(duration: 1.5).delay(0.75), value: hideSplash)
        }
        .ignoresSafeArea()
        .onAppear {
            showFortune = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCollective = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showBottomElements = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { hideSplash = true }
                checkAuthState()
            }
        }
    }
    
    var splashScreen: some View {
        ZStack {
            // Gradient background instead of flat black
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "000000")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Main title with better typography and animation
                Text("FORTUNE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 54))
                    .fontWeight(.bold)
                    .shadow(color: Color.white.opacity(0.4), radius: 10, x: 0, y: 0)
                    .opacity(showFortune ? 1 : 0)
                    .scaleEffect(showFortune ? 1 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: showFortune)
                
                // Bottom elements with improved animations and layout
                VStack(spacing: 24) {
                    Divider()
                        .frame(width: 120, height: 2)
                        .background(Color.white.opacity(0.8))
                    
                    Image("SplashScreenBranding")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 230)
                }
                .opacity(showBottomElements ? 1 : 0)
                .offset(y: showBottomElements ? 0 : 30)
                .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.7), value: showBottomElements)
            }
            .padding(.vertical, 50)
        }
        .onAppear {
            // Sequence the animations
            withAnimation {
                showFortune = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    showBottomElements = true
                }
            }
        }
    }
    
    func checkAuthState() {
        if let user = Auth.auth().currentUser {
            print("User is signed in as: \(user.email ?? "")")
            isSignedIn = true
        } else {
            print("User is not signed in.")
            isSignedIn = false
        }
    }
}



// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
