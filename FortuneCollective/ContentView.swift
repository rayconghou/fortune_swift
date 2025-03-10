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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { hideSplash = true }
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
    @State private var hideHamburger = false
    
    var body: some View {
        ZStack {
            TabView {
                HomeView(hideHamburger: $hideHamburger)
                    .tabItem { Image(systemName: "house.fill") }
                WalletView().tabItem { Image(systemName: "creditcard.fill") }
                PortfolioView().tabItem { Image(systemName: "chart.bar.fill") }
                ChatView().tabItem { Image(systemName: "bubble.left.and.bubble.right.fill") }
                ExploreView().tabItem { Image(systemName: "magnifyingglass.circle.fill") }
            }
            .offset(x: showSidebar ? UIScreen.main.bounds.width * 0.75 : 0)
            .animation(.easeInOut(duration: 0.3), value: showSidebar)
            
            if showSidebar {
                SidebarView(showSidebar: $showSidebar)
                    .transition(.move(edge: .leading))
            }
            
            // Hamburger button appears only if sidebar is closed and hideHamburger is false
            VStack {
                HStack {
                    if !showSidebar && !hideHamburger {
                        Button(action: {
                            withAnimation { showSidebar.toggle() }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding(.top, 60)
                                .padding(.leading, 25)
                                .padding(.bottom, 10)
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
                    Button(action: { print("Profile button pressed") }) {
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
                    NavigationLink(destination: AboutUsView()) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("About Us")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
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

// MARK: - HomeView with Floating Trade Buttons
struct HomeView: View {
    @Binding var hideHamburger: Bool
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedTradeType: String = ""
    @State private var showTradeOptions: Bool = false
    @State private var selectedCoin: String? = nil
    @State private var showPaymentOptions: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Main scrollable content.
                ScrollView {
                    // Use a GeometryReader to capture the scroll offset.
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: OffsetPreferenceKey.self,
                                        value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 1)
                    
                    VStack(spacing: 24) {
                        // Your scroll content goes here.
                        Text("Home Page Content")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.top, 100)
                        ForEach(1...50, id: \.self) { idx in
                            Text("Line \(idx)")
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 80)
                    }
                }
                .background(Color.black)
                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                
                // Floating header with BUY & SELL buttons.
                TradeHeaderView { tradeType in
                    selectedTradeType = tradeType
                    showTradeOptions = true
                }
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            // Confirmation dialog for selecting a coin.
            .confirmationDialog("Choose Coin", isPresented: $showTradeOptions, titleVisibility: .visible) {
                Button("Bitcoin") {
                    selectedCoin = "Bitcoin"
                    showPaymentOptions = true
                }
                Button("Solana") {
                    selectedCoin = "Solana"
                    showPaymentOptions = true
                }
                Button("Ethereum") {
                    selectedCoin = "Ethereum"
                    showPaymentOptions = true
                }
                Button("Cancel", role: .cancel) { }
            }
            // Second confirmation dialog for choosing the payment method.
            .confirmationDialog("Choose Payment Method", isPresented: $showPaymentOptions, titleVisibility: .visible) {
                Button("Custodial Wallet") {
                    // Handle the custodial wallet option.
                    print("\(selectedTradeType) \(selectedCoin ?? "") with Custodial Wallet")
                }
                Button("Apple Pay") {
                    // Handle the Apple Pay option.
                    print("\(selectedTradeType) \(selectedCoin ?? "") with Apple Pay")
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

// MARK: - Floating Trade Header View
struct TradeHeaderView: View {
    // Callback returns the trade type selected ("BUY" or "SELL")
    var tradeAction: (String) -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button(action: { tradeAction("BUY") }) {
                Text("BUY")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            Button(action: { tradeAction("SELL") }) {
                Text("SELL")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        // Adjust padding to account for the safe area at the top.
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
        .padding(.bottom, 10)
    }
}

// MARK: - PreferenceKey to Track Scroll Offset
struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct MembershipApplication: Codable {
    let name: String
    let email: String
    let surveyResponses: [String: AnyCodable] // adapt based on your survey structure
}

// helper type to wrap values; see anycodable from github
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    // Simple implementation for String values
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let str = value as? String {
            try container.encode(str)
        } else {
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable only supports String in this example.")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

struct ReserveView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Form Fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var emailConfirm: String = ""
    @State private var discord: String = ""
    @State private var instagramLink: String = ""
    @State private var instagramConfirm: String = ""
    @State private var ageGroup: String = ""
    @State private var occupation: String = ""
    @State private var whyFit: String = ""
    @State private var goals: String = ""
    @State private var cryptoExperience: String = ""
    @State private var startingCapital: String = ""
    @State private var agreedToTerms: Bool = false
    
    @State private var showConfirmationPopup = false
    @State private var validationErrors: [String: Bool] = [:]
    
    let fieldIDs = [
        "name", "email", "emailConfirm", "discord",
        "instagramLink", "instagramConfirm", "ageGroup",
        "occupation", "whyFit", "goals", "cryptoExperience",
        "startingCapital"
    ]
    .map { ($0, UUID()) }
    .reduce(into: [String: UUID]()) { $0[$1.0] = $1.1 }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
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
                        
                        // Contact Info
                        Group {
                            Text("Provide your contact information.")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Enter your name", text: $name)
                                .id(fieldIDs["name"])
                            showError("name")
                            CustomTextField(placeholder: "Enter your email", text: $email)
                                .id(fieldIDs["email"])
                            showError("email")
                            CustomTextField(placeholder: "Confirm your email", text: $emailConfirm)
                                .id(fieldIDs["emailConfirm"])
                            showError("emailConfirm")
                            CustomTextField(placeholder: "Enter your Discord", text: $discord)
                                .id(fieldIDs["discord"])
                            showError("discord")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("1. What is your Instagram handle?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Paste your profile link", text: $instagramLink)
                                .id(fieldIDs["instagramLink"])
                            showError("instagramLink")
                            CustomTextField(placeholder: "Confirm your Instagram", text: $instagramConfirm)
                                .id(fieldIDs["instagramConfirm"])
                            showError("instagramConfirm")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("2. What is your age group?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            AgeGroupRadioGroup(selectedAgeGroup: $ageGroup)
                                .id(fieldIDs["ageGroup"])
                            showError("ageGroup")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("3. What do you do for work?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Enter your occupation", text: $occupation)
                                .id(fieldIDs["occupation"])
                            showError("occupation")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("4. Why do you think you're a great fit for Fortune Collective?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextEditor(placeholder: "Enter your message here", text: $whyFit)
                                .id(fieldIDs["whyFit"])
                            showError("whyFit")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("5. Share a bit about your goals, what drives you, and what makes you determined to succeed:")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextEditor(placeholder: "Enter your message here", text: $goals)
                                .id(fieldIDs["goals"])
                            showError("goals")
                            Text("We accept fewer than 18% of applicants. Show us why you deserve to join Fortune Collective. The more effort you put in, the better your chances.")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("6. How much crypto experience do you have?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CryptoExperiencePicker(experience: $cryptoExperience)
                                .id(fieldIDs["cryptoExperience"])
                            showError("cryptoExperience")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("7. How much is your starting capital?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            StartingCapitalRadioGroup(selectedCapital: $startingCapital)
                                .id(fieldIDs["startingCapital"])
                            showError("startingCapital")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Acknowledgment")
                                .font(.custom("Inter", size: 18))
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
                                        .font(.system(size: 14))
                                    Button {
                                        // Link to TOS if needed
                                    } label: {
                                        Text("TOS & Privacy Policy.")
                                            .foregroundColor(.gray)
                                            .underline()
                                            .font(.system(size: 14))
                                    }
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            validateFields(proxy: proxy)
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
            }
            
            if showConfirmationPopup {
                Color.black.opacity(0.75).edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Text("Thank you for completing your application.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Return to Home")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(8))
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
    
    private func validateFields(proxy: ScrollViewProxy) {
        let orderedFields: [(key: String, value: String)] = [
            ("name", name),
            ("email", email),
            ("emailConfirm", emailConfirm),
            ("discord", discord),
            ("instagramLink", instagramLink),
            ("instagramConfirm", instagramConfirm),
            ("ageGroup", ageGroup),
            ("occupation", occupation),
            ("whyFit", whyFit),
            ("goals", goals),
            ("cryptoExperience", cryptoExperience),
            ("startingCapital", startingCapital)
        ]
        
        var errors = [String: Bool]()
        var firstErrorField: String?
        
        for field in orderedFields {
            let isEmpty = field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            errors[field.key] = isEmpty
            if isEmpty, firstErrorField == nil {
                firstErrorField = field.key
            }
        }
        
        validationErrors = errors
        
        if let field = firstErrorField, let fieldID = fieldIDs[field] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    proxy.scrollTo(fieldID, anchor: .top)
                }
            }
        } else {
            // All fields are valid—build the survey data and call submitApplication
            let surveyResponses: [String: AnyCodable] = [
                "discord": AnyCodable(discord),
                "instagramLink": AnyCodable(instagramLink),
                "instagramConfirm": AnyCodable(instagramConfirm),
                "ageGroup": AnyCodable(ageGroup),
                "occupation": AnyCodable(occupation),
                "whyFit": AnyCodable(whyFit),
                "goals": AnyCodable(goals),
                "cryptoExperience": AnyCodable(cryptoExperience),
                "startingCapital": AnyCodable(startingCapital)
            ]
            
            let application = MembershipApplication(name: name, email: email, surveyResponses: surveyResponses)
            submitApplication(application) { success in
                if success {
                    // On success, display the confirmation popup.
                    DispatchQueue.main.async {
                        showConfirmationPopup = true
                    }
                } else {
                    // Handle failure (e.g. show an error alert to the user)
                    print("Submission failed")
                }
            }
        }
    }
    
    // Submits the application data to the backend
    func submitApplication(_ application: MembershipApplication, completion: @escaping (Bool) -> Void) {
        let formSubmitURL = "https://formsubmit.co/rayconghou@gmail.com" // Replace with your FormSubmit link
        var request = URLRequest(url: URL(string: formSubmitURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "name": application.name,
            "email": application.email,
            "message": "Why Fit: \(application.surveyResponses["whyFit"]?.value ?? "Not provided")"
        ]
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")
        .data(using: .utf8)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting form: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }.resume()
    }

    
    @ViewBuilder
    private func showError(_ field: String) -> some View {
        if validationErrors[field] ?? false {
            Text("This field is required.")
                .foregroundColor(.red)
                .font(.custom("Inter", size: 14))
        }
    }
}

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

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.custom("Inter", size: 16))
                .frame(minHeight: 100)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.custom("Inter", size: 16))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .allowsHitTesting(false)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct AgeGroupRadioGroup: View {
    @Binding var selectedAgeGroup: String
    let options = ["Under 18", "18-24", "25-33", "33+"]
    var body: some View {
        HStack {
            ForEach(options, id: \.self) { age in
                HStack {
                    Circle()
                        .fill(selectedAgeGroup == age ? Color.white : Color.clear)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: 20, height: 20)
                        .onTapGesture { selectedAgeGroup = age }
                    Text(age)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
    }
}

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
                Button(option) { experience = option }
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
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: 20, height: 20)
                        .onTapGesture { selectedCapital = capital }
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
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack { Image(systemName: "chevron.left") }
                        .foregroundColor(.white)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
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
