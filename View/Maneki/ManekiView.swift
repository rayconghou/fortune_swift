//
//  ManekiView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct ManekiView: View {
    @State private var userMessage = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: 1, content: "Hi there! I'm Maneki, your crypto guide. How can I help you today?", isFromUser: false)
    ]
    
    // 1) A list of example questions the user can tap:
    private let exampleQuestions = [
        "How do I start trading crypto?",
        "What's the safest exchange?",
        "Is now a good time to buy BTC?",
        "Can you explain NFTs?",
        "What are good long-term coins?"
    ]
    
    var body: some View {
        VStack {
            Text("Maneki")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            // 2) The messages scrollable area
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding()
            }
            
            // 3) Horizontal scroll of example questions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(exampleQuestions, id: \.self) { question in
                        Button {
                            // On tap, set userMessage and send
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
            
            // 4) The user message field + send button
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
    }
    
    // Same as your existing send logic
    func sendMessage() {
        guard !userMessage.isEmpty else { return }
        let newMsg = ChatMessage(id: messages.count + 1, content: userMessage, isFromUser: true)
        messages.append(newMsg)
        
        // Sample "AI response"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(
                id: messages.count + 1,
                content: "Here's some info on that: ...",
                isFromUser: false
            )
            messages.append(response)
        }
        userMessage = ""
    }
}
