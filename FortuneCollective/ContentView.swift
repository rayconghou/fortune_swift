//
//  ContentView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var hideSplash = false
    @State private var showFortune = false
    @State private var showCollective = false
    @State private var showBottomElements = false
    
    var body: some View {
        
        ZStack {
            HomePageView()
            
            splashScreen
                .offset(y: hideSplash ? -UIScreen.main.bounds.height : 0) // the splash screen moves up
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    hideSplash = true
                }
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
                
                
                Text("COLLECTIVE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 24))
                    .opacity(showFortune ? 1 : 0)
                    .animation(.easeIn(duration: 0.1).delay(1.0), value: showFortune)
                    .padding(.bottom, 20)
                
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
}

struct HomePageView: View {
    
    @State private var showSidebar = false
    
    var body: some View {
        ZStack {
            
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                
                WalletView()
                    .tabItem {
                        Image(systemName: "creditcard.fill")
                    }
                
                PortfolioView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                    }
                
                ChatView()
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                    }
                
                ExploreView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
            }
            .offset(x: showSidebar ? UIScreen.main.bounds.width * 0.75 : 0)
            .animation(.easeInOut(duration: 0.3), value: showSidebar)
            
            if showSidebar {
                SidebarView(showSidebar: $showSidebar)
                    .transition(.move(edge: .leading))
            }
            
            VStack {
                HStack {
                    
                    if(!showSidebar) {
                        
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 60, leading: 25, bottom: 10, trailing: 0))
                        }
                    }
                    Spacer()
                    
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SidebarView: View {
    @Binding var showSidebar: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
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
                    
                    Button(action: {
                        print("Profile button pressed")
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("James Wang")
                                    .font(.custom("Inter", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Manage Profile")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .padding(.trailing, 30)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                    }
                    
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                    
                    NavigationLink(destination: ReserveView()) {
                        HStack {
                            Image(systemName: "key")
                            
                            Text("Reserve")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                    
                    Button(action: {
                        print("Settings button pressed")
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            
                            Text("Settings")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        print("Notifications button pressed")
                    }) {
                        HStack {
                            Image(systemName: "bell")
                            
                            Text("Notifications")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: AboutUsView()) {
                        HStack {
                            Image(systemName: "info.circle")
                            
                            Text("About Us")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        print("Logout button pressed")
                    }) {
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
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            
        }
    }
}

// MARK: Sidebar Modals / Pages

struct ReserveView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Form Fields
    
    // Q1: Name, Email, Confirm Email, Discord
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var emailConfirm: String = ""
    @State private var discord: String = ""
    
    // Q2: Instagram handle (two fields)
    @State private var instagramLink: String = ""
    @State private var instagramConfirm: String = ""
    
    // Q3: Age group
    @State private var ageGroup: String = "" // "Under 18", "18-24", "25-33", "33+"
    
    // Q4: Occupation
    @State private var occupation: String = ""
    
    // Q5: Why great fit (multiline)
    @State private var whyFit: String = ""
    
    // Q6: Goals, motivations (multiline)
    @State private var goals: String = ""
    
    // Q7: Crypto experience (dropdown) & Starting capital (radio)
    @State private var cryptoExperience: String = ""
    @State private var startingCapital: String = ""
    
    // Terms of service
    @State private var agreedToTerms: Bool = false
    
    // Popup
    @State private var showConfirmationPopup = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reserve your membership.")
                            .font(.custom("Inter", size: 26))
                            .foregroundColor(.white)
                            .bold()
                        Text("7 simple answers.")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    // MARK: - Question 1
                    Group {
                        Text("1. Provide your contact information")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        CustomTextField(
                            placeholder: "Enter your name",
                            text: $name
                        )
                        
                        CustomTextField(
                            placeholder: "Enter your email",
                            text: $email
                        )
                        
                        CustomTextField(
                            placeholder: "Confirm your email",
                            text: $emailConfirm
                        )
                        
                        CustomTextField(
                            placeholder: "Enter your Discord",
                            text: $discord
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 2
                    Group {
                        Text("2. What is your Instagram handle?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        CustomTextField(
                            placeholder: "Paste your profile link",
                            text: $instagramLink
                        )
                        
                        CustomTextField(
                            placeholder: "Confirm your Instagram",
                            text: $instagramConfirm
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 3
                    Group {
                        Text("3. What is your age group?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        AgeGroupRadioGroup(
                            selectedAgeGroup: $ageGroup
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 4
                    Group {
                        Text("4. What do you do for work?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        CustomTextField(
                            placeholder: "Enter your occupation",
                            text: $occupation
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 5
                    Group {
                        Text("5. Why do you think you're a great fit for Fortune Collective?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        CustomTextEditor(
                            placeholder: "Enter your message here",
                            text: $whyFit
                        )
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 6
                    Group {
                        Text("6. Share a bit about your goals, what drives you, and what makes you determined to succeed:")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        CustomTextEditor(
                            placeholder: "Enter your message here",
                            text: $goals
                        )
                        
                        Text("We accept fewer than 18% of applicants. Show us why you deserve to join Fortune Collective. The more effort you put in, the better your chances.")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // MARK: - Question 7
                    Group {
                        Text("7. How much crypto experience do you have?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        // A simple picker or text field
                        CryptoExperiencePicker(experience: $cryptoExperience)
                        
                        Text("How much is your starting capital?")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        StartingCapitalRadioGroup(selectedCapital: $startingCapital)
                    }
                    
                    // MARK: - Acknowledgment
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Acknowledgment")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.white)
                            .bold()
                        
                        Text("Admission to Fortune Collective is NOT free. By applying, you confirm that you’re ready to invest in connecting with 7-figure crypto traders and accessing top-tier strategies.")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Toggle(isOn: $agreedToTerms) {
                            HStack {
                                Text("Agree to our ")
                                    .foregroundColor(.white)
                                Button {
                                    // Perhaps link to TOS
                                } label: {
                                    Text("Terms of Service & Privacy Policy.")
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .foregroundColor(.white)
                    }
                    .padding(.top, 8)
                    
                    // MARK: - Apply Button
                    Button(action: {
                        // Could add field validation here if desired
                        showConfirmationPopup = true
                    }) {
                        Text("Apply")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(agreedToTerms ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .disabled(!agreedToTerms)
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            
            // MARK: - Confirmation Popup
            if showConfirmationPopup {
                Color.black.opacity(0.75).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Application Submitted!")
                        .font(.custom("Inter", size: 22))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text("Thank you for completing your application.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Return to Home")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.cornerRadius(8))
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.9))
                )
                .padding(.horizontal, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Custom Text Field

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.custom("Inter", size: 16))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
            )
    }
}

// MARK: - Custom Text Editor (for multiline input)

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    
    // A simple trick to show a placeholder in a TextEditor
    @State private var showPlaceholder: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.custom("Inter", size: 16))
                    .padding(.top, 8)
                    .padding(.horizontal, 6)
            }
            TextEditor(text: $text)
                .font(.custom("Inter", size: 16))
                .foregroundColor(.white)
                .frame(minHeight: 100)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
        }
    }
}

// MARK: - Age Group Radio Buttons

struct AgeGroupRadioGroup: View {
    @Binding var selectedAgeGroup: String
    
    let options = ["Under 18", "18-24", "25-33", "33+"]

    var body: some View {
        HStack {
            ForEach(options, id: \.self) { age in
                HStack {
                    Circle()
                        .fill(selectedAgeGroup == age ? Color.white : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            selectedAgeGroup = age
                        }
                    Text(age)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
    }
}

// MARK: - Crypto Experience Picker

struct CryptoExperiencePicker: View {
    @Binding var experience: String
    
    let options = [
        "I'm a beginner looking to get started with crypto",
        "I have some experience",
        "I'm quite experienced",
        "I'm a professional trader"
    ]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    experience = option
                }
            }
        } label: {
            HStack {
                Text(experience.isEmpty ? "Select your experience level" : experience)
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 16))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

// MARK: - Starting Capital Radio Group

struct StartingCapitalRadioGroup: View {
    @Binding var selectedCapital: String
    
    let options = [
        "$0-$999",
        "$1,000-$9,999",
        "$10,000-$49,999",
        "$50,000-$99,999",
        "$100,000+"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(options, id: \.self) { capital in
                HStack {
                    Circle()
                        .fill(selectedCapital == capital ? Color.white : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            selectedCapital = capital
                        }
                    
                    Text(capital)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct AboutUsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Meet our admins.")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("This is the Fortune Collective About Us page.")
                .font(.body)
                .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// Individual Tab Pages
struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home Page")
                    .font(.largeTitle)
            }
        }
    }
}

struct WalletView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Wallet Page")
                    .font(.largeTitle)
            }
        }
    }
}

struct PortfolioView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Portfolio View")
                    .font(.largeTitle)
            }
        }
    }
}

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Chat View")
                    .font(.largeTitle)
            }
        }
    }
}

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Explore View")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    ContentView()
}
