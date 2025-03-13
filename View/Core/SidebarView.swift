//
//  SidebarView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

// MARK: - Sidebar with Extra Options

struct SidebarView: View {
    @Binding var showSidebar: Bool
    @Binding var showDegenMode: Bool
    @Binding var selectedTab: Int
    @State private var showManekiIntro = false
    @State private var showChatroom = false
    @ObservedObject var userProfile: UserProfileViewModel
    @State private var showProfileSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Close Button
                HStack {
                    Button(action: { withAnimation { showSidebar.toggle() } }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 25)
                            .padding(.bottom, 20)
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 20) {
                    // The Profile Row
                    Button(action: {
                        showProfileSettings = true
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(userProfile.name)
                                    .font(.custom("Inter", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(userProfile.email)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing, 35)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                    }
                    .sheet(isPresented: $showProfileSettings) {
                        ProfileSettingsView(userProfile: userProfile)
                    }
                    
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                    
                    // Degen Mode Toggle
                    HStack {
                        Image(systemName: "flame.fill")
                        Text("Degen Mode")
                            .font(.custom("Inter", size: 18))
                        Spacer()
                        Toggle("", isOn: $showDegenMode)
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            .padding(.trailing, 30)
                    }
                    .padding(.leading, 30)
                    .foregroundColor(.white)
                    
                    // Maneki Guide Button (Opens Modal)
                    Button(action: { showManekiIntro = true }) {
                        HStack {
                            Image(systemName: "cat.fill")
                            Text("Maneki Guide")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showManekiIntro) {
                        // Pass both selectedTab and showSidebar
                        ManekiIntroView(selectedTab: $selectedTab, showSidebar: $showSidebar)
                    }
                    
                    // Chatroom
                    Button(action: { showChatroom = true }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Chatroom")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showChatroom) {
                        ChatroomView()
                    }
                    
                    // Community Hub
                    NavigationLink(destination: CommunityHubView()) {
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("Community Hub")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    // Newsletter
                    NavigationLink(destination: NewsletterView()) {
                        HStack {
                            Image(systemName: "newspaper.fill")
                            Text("Newsletter")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                
                    
                    // Settings & Notifications
                    Button(action: { print("Settings button pressed") }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    Button(action: { print("Notifications button pressed") }) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Notifications")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }

                    // Logout
                    Button(action: { print("Logout button pressed") }) {
                        HStack {
                            Image(systemName: "power")
                            Text("Logout")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - Additional Views & Support Components

struct ManekiIntroView: View {
    @Binding var selectedTab: Int
    @Binding var showSidebar: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                HStack {
                    Spacer()
                    // Close Modal Button
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                Image(systemName: "cat.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)

                Text("Welcome to Maneki!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Maneki is here to guide you through using Fortune Collective. Ask questions about market trends, portfolio tips, or get crypto insights.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Close modal
                    showSidebar = false  // Close sidebar
                    selectedTab = 2  // Go to Maneki tab
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                        Text("Go to Maneki")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 30)

            }
            .padding()
        }
        .background(Color.black)
    }
}


struct ChatroomView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Text("Chatroom")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                Text("This feature is coming soon!")
                    .foregroundColor(.gray)
                Spacer()
            }
            .background(Color.black)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
            })
        }
        .preferredColorScheme(.dark)
    }
}

struct CommunityHubView: View {
    var body: some View {
        VStack {
            Text("Community Hub")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Connect with other crypto enthusiasts!")
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.black)
    }
}

struct NewsletterView: View {
    var body: some View {
        VStack {
            Text("Newsletter")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Subscribe for the latest crypto updates.")
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.black)
    }
}
