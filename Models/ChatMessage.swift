//
//  ChatMessage.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable {
    let id: Int
    let content: String
    let isFromUser: Bool
}

struct ChatBubble: View {
    let message: ChatMessage
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            Text(message.content)
                .padding()
                .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(18)
                .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            if !message.isFromUser { Spacer() }
        }
    }
}
