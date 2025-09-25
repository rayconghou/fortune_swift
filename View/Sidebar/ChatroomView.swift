//
//  Chatroom.swift
//  Dojo
//
//  Created by Raymond Hou on 4/8/25.
//

import Foundation
import SwiftUI

struct ChatroomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("Chats")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            viewModel.showCreateGroupSheet = true
                        }) {
                            Label("Create Group", systemImage: "person.3")
                        }
                        
                        Button(action: {
                            viewModel.showFriendRequestSheet = true
                        }) {
                            Label("Friend Requests", systemImage: "person.badge.plus")
                        }
                        
                        Button(action: {
                            viewModel.showProfileSheet = true
                        }) {
                            Label("Profile", systemImage: "person.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                
                // Tabs
                HStack {
                    TabButton(title: "Chats", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabButton(title: "Friends", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $viewModel.searchText)
                        .foregroundColor(.white)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                if selectedTab == 0 {
                    // Chat list
                    if viewModel.selectedChatRoom == nil {
                        // Show chat list when no chat is selected
                        chatListView
                    } else {
                        // Show selected chat
                        chatDetailView
                    }
                } else {
                    // Friends list
                    friendsListView
                }
            }
        }
        .sheet(isPresented: $viewModel.showCreateGroupSheet) {
            createGroupView
        }
        .sheet(isPresented: $viewModel.showFriendRequestSheet) {
            friendRequestsView
        }
        .sheet(isPresented: $viewModel.showProfileSheet) {
            userProfileView
        }
        .preferredColorScheme(.dark)
    }
    
    // Chat list
    var chatListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredChatRooms()) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom) {
                        viewModel.selectedChatRoom = chatRoom
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    // Chat detail view
    var chatDetailView: some View {
        VStack(spacing: 0) {
            // Chat header
            HStack {
                Button(action: {
                    viewModel.selectedChatRoom = nil
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Image(systemName: viewModel.selectedChatRoom?.icon ?? "message")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(viewModel.selectedChatRoom?.name ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.selectedChatRoom?.participants.count ?? 0) participants")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    // Show chat info/settings
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.black)
            
            // Messages
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.selectedChatRoom?.messages ?? []) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message input
            HStack {
                Button(action: {
                    // Add attachment
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                }
                
                TextField("Message", text: $viewModel.messageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(18)
                    .foregroundColor(.white)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                }
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color.black.opacity(0.95))
        }
    }
    
    // Friends list
    var friendsListView: some View {
        VStack {
            if viewModel.friends.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No friends yet")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Add friends to chat and make plans together")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        viewModel.showFriendRequestSheet = true
                    }) {
                        Text("Find Friends")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 44)
                            .background(Color.blue)
                            .cornerRadius(22)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.friends) { friend in
                            FriendCell(user: friend) {
                                // Create or open direct chat with friend
                                if let existingChat = viewModel.chatRooms.first(where: {
                                    $0.type == .direct &&
                                    $0.participants.contains(where: { $0.id == friend.id }) &&
                                    $0.participants.count == 2
                                }) {
                                    viewModel.selectedChatRoom = existingChat
                                    selectedTab = 0
                                } else {
                                    let directChat = ChatRoom(
//                                        id: UUID(),
                                        name: friend.username,
                                        description: "Direct message",
                                        type: .direct,
                                        participants: [viewModel.currentUser, friend]
                                    )
                                    viewModel.chatRooms.append(directChat)
                                    viewModel.selectedChatRoom = directChat
                                    selectedTab = 0
                                }
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    // Create group view
    var createGroupView: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Create Group")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Group Name", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Text("Add Friends")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ScrollView {
                        ForEach(viewModel.friends) { friend in
                            HStack {
                                Image(systemName: friend.profileImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .foregroundColor(.blue)
                                
                                Text(friend.username)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Button(action: {
                        viewModel.showCreateGroupSheet = false
                    }) {
                        Text("Create Group")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Cancel") {
                viewModel.showCreateGroupSheet = false
            })
        }
    }
    
    // Friend requests view
    var friendRequestsView: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    if viewModel.pendingFriendRequests.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No friend requests")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Search username", text: .constant(""))
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                            Button(action: {}) {
                                Text("Send Request")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 44)
                                    .background(Color.blue)
                                    .cornerRadius(22)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.pendingFriendRequests) { user in
                                HStack {
                                    Image(systemName: user.profileImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .foregroundColor(.blue)
                                    
                                    Text(user.username)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.addFriend(user: user)
                                    }) {
                                        Text("Accept")
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.blue)
                                            .cornerRadius(16)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Friend Requests")
            .navigationBarItems(trailing: Button("Done") {
                viewModel.showFriendRequestSheet = false
            })
        }
    }
    
    // User profile view
    var userProfileView: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image(systemName: viewModel.currentUser.profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text(viewModel.currentUser.username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(viewModel.friends.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Friends")
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("\(viewModel.chatRooms.filter { $0.type == .group }.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Groups")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        // Edit profile
                    }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 44)
                            .background(Color.blue)
                            .cornerRadius(22)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") {
                viewModel.showProfileSheet = false
            })
        }
    }
}

// Helper Views
struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: chatRoom.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(chatRoom.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(chatRoom.messages.last?.content ?? chatRoom.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if !chatRoom.messages.isEmpty {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(formatTime(chatRoom.messages.last?.timestamp ?? Date()))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct FriendCell: View {
    let user: ChatUser
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: user.profileImage)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue)
                        .clipShape(Circle())
                    
                    if user.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.username)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(user.isOnline ? "Online" : "Offline")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "message")
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 60)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    Image(systemName: message.sender.profileImage)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.gray)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.sender.username)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(message.content)
                            .padding(12)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(18)
                        
                        Text(formatTime(message.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .gray)
                
                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(height: 3)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChatroomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatroomView()
            .preferredColorScheme(.dark)
    }
}
