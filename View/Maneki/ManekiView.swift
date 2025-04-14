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
        let newMsg = ManekiChatMessage(id: messages.count + 1, content: userMessage, isFromUser: true)
        messages.append(newMsg)
        
        // Sample "AI response"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ManekiChatMessage(
                id: messages.count + 1,
                content: "Here's some info on that: ...",
                isFromUser: false
            )
            messages.append(response)
        }
        userMessage = ""
    }
}
