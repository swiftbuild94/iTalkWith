//
//  iTalk.swift
//  iTalk
//
//  Created by Patricio Benavente on 26/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI

struct iTalkView: View {
	@ObservedObject private var vm = ContactsVM()
    @State private var shouldShowNewUserScreen = false
    @State private var shouldNavigateToChatView = false
    @State private var userSelected: User?

    var columns = [
        GridItem(spacing: 0),
        GridItem(spacing: 0)
    ]
    
	var body: some View {
		NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                    .foregroundColor(Color.red)
                LazyVGrid(columns: columns, spacing: 0){
                    ForEach(vm.recentMessages, id:\.self) { recentMessage in
                        let uid = recentMessage.toId
                        let user = vm.usersDictionary[uid]
                        if let user = user {
                            //  if UIDevice.current.userInterfaceIdiom == .pad {
                            NavigationLink(destination: ChatView(chatUser: user)) {
                                VStack {
                                    HistoryCell(contact: user, recentMessage: recentMessage)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                print("Pinned")
                                            } label: {
                                                Label("Pin",systemImage: "pin")
                                                    .foregroundColor(Color(.blue))
                                            }
                                            .tint(.orange)
                                        }
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
                            }
                            //   } else {
                            //                            Button {
                            //                                vm.selectedUser = user.uid
                            //                                vm.isShowChat = true
                            //                            } label : {
                            //                                HistoryCell(contact: user, recentMessage: recentMessage)
                            //                            }
                            //  }
                        }
                    }
                }
                ForEach(vm.users, id:\.self) { user in
                    if let user = user {
                        NavigationLink(destination: ChatView(chatUser: user)) {
                            ContactCell(contact: user)
                        }
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
        iTalkView()
//            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 mini")
    }
}
