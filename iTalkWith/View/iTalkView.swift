//
//  iTalk.swift
//  iTalk
//
//  Created by Patricio Benavente on 26/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI

struct iTalkView: View {
	@ObservedObject private var vmContacts = ContactsVM()
    @State private var shouldShowNewUserScreen = false
    @State private var shouldNavigateToChatView = false
    @Binding var userSelected: User?
   // @Binding var isShowChat: Bool
    @ObservedObject private var vmChats = ChatsVM(chatUser: nil)
    
    var columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
	var body: some View {
		NavigationView {
            ScrollView {
                Text(vmContacts.errorMessage)
                    .foregroundColor(Color.red)
                LazyVGrid(columns: columns, spacing: 0){
                    ForEach(vmContacts.recentMessages, id:\.self) { recentMessage in
                        let uid = recentMessage.toId
                        let user = vmContacts.usersDictionary[uid]
                        if let user = user {
                            //  if UIDevice.current.userInterfaceIdiom == .pad {
//                            NavigationLink(destination: //ChatView(chatUser: user)) {
//                                ChatView(vmChats: vmChats) {
                            Button(action: {
                                    userSelected = user
                                    //vmChats.chatUser = user
                                    //vmChats.fetchMessages()
                                    print("UserSelected: \(user.name)")
                                
                                //isShowChat.toggle()
                                // ChatView(vmChats: vmChats)
                            }, label: {
                                GridCell(contact: user, recentMessage: recentMessage)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            print("Pinned")
                                        } label: {
                                            Label("Pin",systemImage: "pin")
                                                .foregroundColor(Color(.blue))
                                        }
                                        .tint(.orange)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            print("UserDetails")
                                        } label: {
                                            Label("User Details",systemImage: "person.crop.circle.badge.questionmark")
                                                .foregroundColor(Color(.blue))
                                        }
                                        .tint(.blue)
                                        Button(role: .destructive) {
                                            print("Archive")
                                        } label: {
                                            Label("Archive",systemImage: "archivebox")
                                                .foregroundColor(Color(.blue))
                                        }
                                        .tint(.gray)
                                    }
                            })
                        }
                    }
                }
                Divider()
                ForEach(vmContacts.users, id:\.self) { user in
                    if let user = user {
                        Button(action: {
                            userSelected = user
                        }, label: {
                            ContactCell(contact: user)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        print("Pinned")
                                    } label: {
                                        Label("Pin",systemImage: "pin")
                                            .foregroundColor(Color(.blue))
                                    }
                                    .tint(.orange)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        print("UserDetails")
                                    } label: {
                                        Label("User Details",systemImage: "person.crop.circle.badge.questionmark")
                                            .foregroundColor(Color(.blue))
                                    }
                                    .tint(.blue)
                                    Button(role: .destructive) {
                                        print("Archive")
                                    } label: {
                                        Label("Archive",systemImage: "archivebox")
                                            .foregroundColor(Color(.blue))
                                    }
                                    .tint(.gray)
                                }
                        })
                    }
                }
//                    if UIDevice.current.userInterfaceIdiom == .pad {
            }
                .navigationBarTitle(Text("iTalkWith"))
//            
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            //                          chatMode.showUserDetails()
//                        } label: {
//                            Image(systemName: "person.crop.circle.badge.plus")
//                        }
//                    }
//                }
        }
	}
}


struct iTalk_Previews: PreviewProvider {
    static var previews: some View {
        iTalkView(userSelected: .constant(nil))
//            .preferredColorScheme(.dark)
            .previewDevice("iPhone 14 Pro")
    }
}
