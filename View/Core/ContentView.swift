//
//  ContentView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import Combine
import PassKit

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}

// MARK: - Main ContentView with Splash Screen

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


// MARK: - Profile Modal

class UserProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var email: String
    
    init(name: String = "James Wang", email: String = "james@example.com") {
        self.name = name
        self.email = email
    }
}

struct ProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Profile Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Name & Email
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name").foregroundColor(.gray)
                    TextField("Name", text: $userProfile.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Email").foregroundColor(.gray)
                    TextField("Email", text: $userProfile.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 20)
                
                // The mock Apple Pay button:
                MockApplePayButton()
                    .frame(width: 200, height: 44) // approximate size
                
                Spacer()
                
                // Dismiss button
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                .padding(.bottom, 50)
                
            }
            .padding()
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Apple Pay Integration (mockup as of 3/11)

struct MockApplePayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.mockPaymentFlow), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func mockPaymentFlow() {
            print("User tapped the mock Apple Pay button.")
            
            let alert = UIAlertController(
                title: "Mock Apple Pay",
                message: "This is a prototype flow.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // Find the top-most view controller to present the alert
            if let topVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?
                .rootViewController {
                
                DispatchQueue.main.async {
                    topVC.present(alert, animated: true)
                }
            }
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



// MARK: - Support Views

struct CryptoTrendCard: View {
    let name: String
    let symbol: String
    let price: Double
    /// This is the 24h change in percent (e.g. -3.12 means -3.12%)
    let change: Double
    
    var body: some View {
        // Decide if it’s positive or negative
        let isPositive = change >= 0
        // Format the numeric change to a percentage string
        let changeString = String(format: "%.2f%%", change)
        
        HStack {
            // Left section: Crypto logo + name + symbol
            Image(symbol.uppercased())  // Uses BTC, ETH, SOL image names
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .clipShape(Circle()) // Ensures a round shape for consistency
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            // Right section: price + 24h change with icon
            VStack(alignment: .trailing) {
                // Current price formatted as currency:
                Text(price.asCurrency)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    // Icon: arrow up or down
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .resizable()
                        .foregroundColor(isPositive ? .green : .red)
                        .frame(width: 10, height: 10)
                    
                    // The text “+1.23%” or “-2.34%”
                    Text(changeString)
                        .font(.subheadline)
                        .foregroundColor(isPositive ? .green : .red)
                        .padding(.leading, 5)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NewsCard: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct IndexCard: View {
    let name: String
    let value: String
    let change: String
    
    var isPositive: Bool {
        return change.contains("+")
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .trailing) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(change)
                    .font(.subheadline)
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DegenTradingCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Action for trading option
            }) {
                Text("Start Trading")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(height: 90)
        .frame(minWidth: 300)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}



struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
