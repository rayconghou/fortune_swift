//
//  HomePageView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

// MARK: - HomePageView with TabView and Sidebar

struct HomePageView: View {
    @State private var showSidebar = false
    @State private var hideHamburger = false
    @State private var showDegenMode = false
    @State private var showManekiButton = true
    @StateObject private var userProfile = UserProfileViewModel()
    @State private var selectedTab: Int = 0  // Track selected tab
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SpotView(hideHamburger: $hideHamburger)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "binoculars.fill")
                    }
                
                IndexesView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                    }
                
                ManekiView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "cat.fill")
                            .font(.system(size: 28))
                    }
                
                PortfolioView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                    }
                
                DegenView(isEnabled: $showDegenMode)
                    .tag(4)
                    .tabItem {
                        Image(systemName: "flame.fill")
                    }
            }
            .offset(x: showSidebar ? UIScreen.main.bounds.width * 0.75 : 0)
            .animation(.easeInOut(duration: 0.3), value: showSidebar)
            
            if !hideHamburger {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding(.top, 25)
                                .padding(.leading, 15)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.leading, 5)
                .padding(.top, 40)
            }
            
            if showSidebar {
                SidebarView(showSidebar: $showSidebar, showDegenMode: $showDegenMode, selectedTab: $selectedTab, userProfile: userProfile)
                    .transition(.move(edge: .leading))
                    .onAppear { withAnimation { showManekiButton = false } }
                    .onDisappear { withAnimation { showManekiButton = true } }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
