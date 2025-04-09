//
//  ContentView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import Combine
import FirebaseAuth

// MARK: - Main ContentView with Splash Screen

struct ContentView: View {
    @State private var hideSplash = false
    @State private var showFortune = false
    @State private var showCollective = false
    @State private var showBottomElements = false
    @State private var isSignedIn = false

    
    var body: some View {
        ZStack {
            Group {
                if isSignedIn {
                    HomePageView()
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
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("FORTUNE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 48))
                    .opacity(showFortune ? 1 : 0)
                    .animation(.easeIn(duration: 0.1).delay(0.3), value: showFortune)
                VStack {
                    Divider()
                        .background(Color.white)
                        .frame(width: 200, height: 5)
                    Image("SplashScreenBranding")
                        .resizable()
                        .frame(width: 200, height: 210)
                }
                .opacity(showBottomElements ? 1 : 0)
                .offset(y: showBottomElements ? 0 : 50)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: showBottomElements)
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
    }
}
