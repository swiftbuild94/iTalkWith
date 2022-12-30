//
//  MessagesView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI

/// Show the list of messages
struct MessagesView: View {
    @EnvironmentObject var vmChats: ChatsVM
    private let topPadding: CGFloat = 10
    static let bottomAnchor = "BottomAnchor"
    //    var chatUser: User
    
    //    init(chatUser: User){
    //        self.chatUser = chatUser
    //        self.vm = .init(chatUser: chatUser)
    //    }
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    LazyVStack {
                        ForEach(vmChats.chatMessages) { message in
                            MessageView(message: message)
                        }
                        HStack { Spacer() }
                            .id(Self.bottomAnchor)
                    }
                    .onReceive(vmChats.$count) { _ in
                        withAnimation(.easeOut(duration: 0.4)) {
                            scrollViewProxy.scrollTo(Self.bottomAnchor, anchor: .bottom)
                        }
                    }
                }
            }
        }
        //        .background(.gray)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
