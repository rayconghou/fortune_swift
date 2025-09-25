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
    @State static var webSocketManager: WebSocketManager = WebSocketManager()
    
    var body: some View {
        ZStack {
            Group {
                if authViewModel.isLoggedIn {
                    if let userProfile = AuthManager.shared.userProfile {
                        SecureSignInFlowView(userProfile: userProfile)
                            .environmentObject(ContentView.securityViewModel)
                    } else {
                        // Loading state - will be replaced by mock profile after splash
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Loading...")
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            Text("Frontend Development Mode")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                    }
                } else {
                    // Fallback to AuthView with debug info
                    VStack {
                        AuthView()
                        
                        // Debug info
                        VStack {
                            Text("Debug Info:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("isLoggedIn: \(authViewModel.isLoggedIn ? "true" : "false")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("hideSplash: \(hideSplash ? "true" : "false")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }
            .zIndex(0)
            
            splashScreen
                .opacity(hideSplash ? 0 : 1)
        }
        .ignoresSafeArea()
        .onAppear {
            showFortune = true
            
            // Debug authentication state
            print("Auth state on appear - isLoggedIn: \(authViewModel.isLoggedIn)")
            print("User profile: \(AuthManager.shared.userProfile?.email ?? "nil")")
            
            // Start connecting - COMMENTED OUT FOR FRONTEND DEVELOPMENT
            // if let url = URL(string: "wss://6kmh7sue9j.execute-api.us-east-2.amazonaws.com/production/") {
            //     ContentView.webSocketManager.connect(url:  url)
            // }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCollective = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showBottomElements = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { hideSplash = true }
                print("Splash hidden - Auth state: \(authViewModel.isLoggedIn)")
                print("User profile after splash: \(AuthManager.shared.userProfile?.email ?? "nil")")
                
                // MOCK: Create user profile for frontend development
                if authViewModel.isLoggedIn && AuthManager.shared.userProfile == nil {
                    AuthManager.shared.userProfile = UserProfileViewModel(
                        email: Auth.auth().currentUser?.email ?? "demo@example.com",
                        username: "Demo User"
                    )
                    print("Created mock user profile for frontend development")
                }
            }
        }
    }
    
    var splashScreen: some View {
        ZStack {
            // Custom background color #050715
            Color(hex: "050715")
                .edgesIgnoringSafeArea(.all)
            
            // NormalSplashBackground asset overlay
            Image("NormalSplashBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // DOJO Logo and Text from SplashScreenBranding asset
                Image("SplashScreenBranding")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
            }
            .padding(.vertical, 50)
        }
        .onAppear {
            // No animations - just show immediately
        }
    }
    
//    func checkAuthState() {
//        if let user = Auth.auth().currentUser {
//            print("User is signed in as: \(user.email ?? "")")
//            isSignedIn = true
//        } else {
//            print("User is not signed in.")
//            isSignedIn = false
//        }
//    }

}




// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

// MARK: - DOJO Splash Preview
struct DojoSplashPreview: View {
    @State private var showFortune = false
    
    var body: some View {
        ZStack {
            Color(hex: "050715")
                .edgesIgnoringSafeArea(.all)
            
            // NormalSplashBackground asset overlay
            Image("NormalSplashBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // DOJO Logo and Text from SplashScreenBranding asset
                Image("SplashScreenBranding")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            // No animations - just show immediately
        }
    }
}

#Preview("DOJO Splash") {
    DojoSplashPreview()
}
