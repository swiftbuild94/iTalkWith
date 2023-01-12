//
//  ChatView.swift
//  iTalk
//
//  Created by Patricio Benavente on 9/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {
    //@Environment(\.presentationMode) var chatMode
    //    @ObservedObject private var vmLogin = LogInSignInVM()
    @StateObject var vmChats = ChatsVM()
    @State var zoomed = false
    @State var shouldShowImagePicker = false
    @State var shouldShowLocation = false
    @StateObject var audioRecorder = AudioRecorder()
    @FocusState var focus
    @EnvironmentObject var vmContacts: ContactsVM
    //var contact: User?
    let topPadding: CGFloat = 8
    @State var isAllowedToRecord = false
    @State var isActivityIndicator = true
    var contact: User
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack() {
                Divider()
                // if isActivityIndicator {
                //  ActivityIndicator($isActivityIndicator, style: .large)
                // } else {
                MessagesView()
                    .padding(.bottom, topPadding)
                // }
                InputsButtons()
                if vmChats.typeOfContent == .text {
                    ChatTextBar(vm: vmChats)
                } else if vmChats.typeOfContent == .audio {
                    ChatAudioBar()
                }
            }
        }
        .onAppear() {
            self.isAllowedToRecord = self.audioRecorder.isAllowedToRecord()
            self.vmChats.setUser(chatUser: contact)
            self.focus = vmChats.focus
            DispatchQueue.main.async {
                self.vmChats.getMessages()
               // self.isActivityIndicator.toggle()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)  {
                Button {
                    //userSelected = nil
                } label: {
                    Text("Back")
                }
            }
            ToolbarItem(placement: .principal) {
                Button {
                    // TODO: show user details
                    //  chatMode.showUserDetails()
                } label: {
                    ContactImage(contact: contact)
                    Text(contact.name)
                        .foregroundColor(Color.accentColor)
                        .dynamicTypeSize(.xxxLarge)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing)  {
                Image(systemName: "phone.fill")
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
                Image(systemName: "video.fill")
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
            }
        }
        .onDisappear {
            vmChats.firestoreListener?.remove()
        }
        .sheet(isPresented: $vmChats.shouldShowImagePicker, onDismiss: {
            if vmChats.image != nil {
                vmChats.handleSend(.photoalbum)
                vmChats.count += 1
                vmChats.getMessages()
            }
        }) {
            VStack {
				ImagePicker(selectedImage: $vmChats.image, didSet: $shouldShowImagePicker, sourceType: .photoLibrary)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $vmChats.shouldShowLocation, onDismiss: {
            if vmChats.location != nil {
                vmChats.handleSend(.location)
                vmChats.count += 1
                vmChats.getMessages()
            }
        }, content: {
            VStack {
                MapView()
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $vmChats.shouldShowCamara, onDismiss: {
            if vmChats.location != nil {
                vmChats.handleSend(.location)
                vmChats.count += 1
                vmChats.getMessages()
            }
        }, content: {
			VStack {
				ImagePicker(selectedImage: $vmChats.image, didSet: $shouldShowImagePicker, sourceType: .camera)
			}
			.presentationDetents([.large, .medium])
            .presentationDragIndicator(.visible)
        })
        .environmentObject(vmChats)
    }
}



// MARK: - ContactImage
/// Shows the Contact Image
struct ContactImage: View {
    var contact: User?
    private let imageSize: CGFloat  = 40
    private let imagePadding: CGFloat = 8
    private let shadowRadius: CGFloat = 15
    private let circleLineWidth: CGFloat = 1
    private let cornerRadius: CGFloat = 38
    
    var body: some View {
        if contact != nil {
            if contact!.profileImageURL == nil {
                Image(systemName: "person.fill")
                    .clipShape(Circle())
                    .shadow(radius: shadowRadius)
                    .overlay(Circle().stroke(Color.black, lineWidth: circleLineWidth))
                    .font(.system(size: imageSize))
                    .padding(imagePadding)
            } else {
                Image(contact!.profileImageURL!)
                WebImage(url: URL(string: contact!.profileImageURL!))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(.label), lineWidth: circleLineWidth) )
            }
        }
    }
}


// MARK: - Preview
let data: [String: Any] = ["name": "Test"]
let userTest = User(data: data)

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(contact: userTest)
            .previewDevice("iPhone 14 Pro")
            //.preferredColorScheme(.dark)
            .environmentObject(ChatsVM())
    }
}
