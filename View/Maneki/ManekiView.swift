//
//  ManekiView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct ManekiView: View {
    var hamburgerAction: () -> Void
    @State private var userMessage = ""
    @State private var messages: [ManekiChatMessage] = [
        ManekiChatMessage(id: 1, content: "Hi there! I'm Maneki, your crypto guide. How can I help you today?", isFromUser: false)
    ]
    
    // 1) A list of example questions the user can tap:
    private let exampleQuestions = [
        "How do I start trading crypto?",
        "What's the safest exchange?",
        "Is now a good time to buy BTC?",
        "Can you explain NFTs?",
        "What are good long-term coins?"
    ]
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                // Messages ScrollView
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(messages) { message in
                            ManekiChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                // Example Questions ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(exampleQuestions, id: \.self) { question in
                            Button {
                                userMessage = question
                                sendMessage()
                            } label: {
                                Text(question)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 5)

                // Message Input Area
                HStack {
                    TextField("Ask Maneki anything...", text: $userMessage)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                        .foregroundColor(.white)
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
            .background(Color.black)
            
            // Blurred toolbar overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .ignoresSafeArea()
                .opacity(0.95)
        }
    }
    
    // Same as your existing send logic
    func sendMessage() {
        guard !userMessage.isEmpty else { return }

        // Append the user's message to the list
        let newMsg = ManekiChatMessage(id: messages.count + 1, content: userMessage, isFromUser: true)
        messages.append(newMsg)

        // Build the full message history for context
        let history = messages.map { $0.content }
        userMessage = "" // clear input

        // Prepare request to your backend
        guard let url = URL(string: "http://localhost:3001/api/maneki-chat") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["messages": history]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        // Send API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }

            // 🔍 Debug: Print raw JSON response
            if let raw = String(data: data, encoding: .utf8) {
                print("🧾 Raw response from API:", raw)
            }

            // Now try decoding
            if let result = try? JSONDecoder().decode(ChatResponse.self, from: data) {
                DispatchQueue.main.async {
                    let aiMessage = ManekiChatMessage(id: messages.count + 1, content: result.response, isFromUser: false)
                    messages.append(aiMessage)
                }
            } else {
                print("❌ Failed to decode. Raw JSON printed above.")
            }
        }.resume()

    }

}

struct ChatResponse: Decodable {
    let response: String
}
