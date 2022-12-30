//
//  MessageView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI

/// Shows the message in bubbles incoming and outgoing
struct MessageView: View {
    @EnvironmentObject var vmChats: ChatsVM
    
    let message: Chat
    private let topPadding: CGFloat = 8
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        BubbleView(message: message)
                    }
                    .padding()
                    .background(vmChats.bubbleColor)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, topPadding)
            } else {
                HStack {
                    HStack {
                        BubbleView(message: message)
                    }
                    .padding()
                    .background(.gray)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, topPadding)
            }
        }
    }
}

let chat = Chat(id: "", fromId: "", toId: "", text: "text", photo: nil, audio: nil, audioTimer: nil, audioLocalURL: nil, timestamp: Date() )
struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: chat)
            .environmentObject(ChatsVM())
    }
}
