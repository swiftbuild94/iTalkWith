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
	@Environment(\.presentationMode) var chatMode
//    @ObservedObject private var vmLogin = LogInSignInVM()
    @ObservedObject private var vmChat: ChatsVM
	@State private var zoomed = false
//	@State private var typeOfContent: TypeOfContent = .text
//    @State private var image: UIImage?
    @State private var shouldShowImagePicker = false
    @State private var shouldShowLocation = false
    @FocusState private var focus
	private var contact: User
	private let topPadding: CGFloat = 8
    @ObservedObject private var vmContacts = ContactsVM()
	init(chatUser: User){
		self.contact = chatUser
		self.vmChat = .init(chatUser: chatUser)
        self.focus = vmChat.focus
	}
	
	var body: some View {
            ZStack(alignment: .top) {
                VStack() {
                    MessagesView(vm: vmChat)
                        .padding(.bottom, topPadding)
                    InputsButtons(vm: vmChat)
                    if vmChat.typeOfContent == .text {
                        ChatTextBar(vm: vmChat)
                    } else if vmChat.typeOfContent == .audio {
                        ChatAudioBar(vmChat: vmChat)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
//                          chatMode.showUserDetails()
                    } label: {
                        ContactImage(contact: contact)
                        Text(contact.name)
                            .foregroundColor(Color.accentColor)
                            .dynamicTypeSize(.xxxLarge)
                    }
                }
//                ToolbarItemGroup(placement: .navigationBarTrailing)  {
//                    Image(systemName: "phone.fill")
//                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
//                    Image(systemName: "video.fill")
//                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
//                }
            }
			.onDisappear {
                
			}
            .fullScreenCover(isPresented: $vmChat.shouldShowImagePicker, onDismiss: {
                if vmChat.image != nil {
                    vmChat.handleSend(.photoalbum)
                    vmChat.count += 1
                    vmChat.getMessages()
                }
            }) {
                ImagePicker(selectedImage: $vmChat.image, didSet: $shouldShowImagePicker)
			}
            .fullScreenCover(isPresented: $vmChat.shouldShowLocation, onDismiss: {
                if vmChat.location != nil {
                    vmChat.handleSend(.location)
                    vmChat.count += 1
                    vmChat.getMessages()
                }
            }) {
                MapView(vmChat: vmChat)
            }
	}
}



// MARK: - ContactImage
/// Shows the Contact Image
struct ContactImage: View {
	var contact: User
	private let imageSize: CGFloat  = 40
	private let imagePadding: CGFloat = 8
	private let shadowRadius: CGFloat = 15
	private let circleLineWidth: CGFloat = 1
	private let cornerRadius: CGFloat = 38
    
    var body: some View {
        if contact.profileImageURL == nil {
            Image(systemName: "person.fill")
                .clipShape(Circle())
                .shadow(radius: shadowRadius)
                .overlay(Circle().stroke(Color.black, lineWidth: circleLineWidth))
                .font(.system(size: imageSize))
                .padding(imagePadding)
        } else {
            Image(contact.profileImageURL!)
            WebImage(url: URL(string: contact.profileImageURL!))
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


//  MARK: - Messages
/// Show the list of messages
struct MessagesView: View {
	@ObservedObject var vm: ChatsVM
	private let topPadding: CGFloat = 10
	static let bottomAnchor = "BottomAnchor"
//	var chatUser: User
	
//	init(chatUser: User){
//		self.chatUser = chatUser
//		self.vm = .init(chatUser: chatUser)
//	}
	
	var body: some View {
        ZStack(alignment: .top){
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    LazyVStack {
                        ForEach(vm.chatMessages) { message in
                            MessageView(vm: vm, message: message)
                        }
                        HStack { Spacer() }
                        .id(Self.bottomAnchor)
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.bottomAnchor, anchor: .bottom)
                        }
                    }
                }
            }
        }
//        .background(.gray)
	}
}


// MARK: - MessageView
/// Shows the message in bubbles incoming and outgoing
struct MessageView: View {
    @ObservedObject var vm: ChatsVM
    
	let message: Chat
	private let topPadding: CGFloat = 8

	var body: some View {
		VStack {
			if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
				HStack {
					Spacer()
                    HStack {
                        Bubble(vm: vm, message: message)
                    }
					.padding()
                    .background(vm.bubbleColor)
					.cornerRadius(8)
				}
				.padding(.horizontal)
				.padding(.top, topPadding)
			} else {
				HStack {
					HStack {
                        Bubble(vm: vm, message: message)
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

// MARK: - Bubble
/// Show text, photo, audio in buble
struct Bubble: View {
    @ObservedObject var vm: ChatsVM
    let message: Chat
    
    var body: some View {
        if message.photo != nil {
            ShowPhoto(vm: vm, message: message)
        }
        if message.audio != nil {
            ShowAudio(vm: vm, message: message)
        } else {
            ShowText(message: message)
        }
    }
}


// MARK: - ShowText
/// Shows text in bubble if is url acts according
struct ShowText: View {
    let message: Chat
    
    var body: some View {
        if let text = message.text {
            if ((text.prefix(7) == "http://") || (message.text?.prefix(8) == "https://")) {
                Link(text, destination: URL(string: text)!)
                    .foregroundColor(.blue)
            } else if text.prefix(4) == "www." {
                Link(text, destination: URL(string: "http://" + text)!)
                    .foregroundColor(.blue)
            } else if text.isEmail() {
                Link(text, destination: URL(string: "mailto:" + text)!)
                    .foregroundColor(.blue)
//            } else if text.contains("://") {
                    Link(text, destination: URL(string: text)!)
                        .foregroundColor(.blue)
            } else if text.isPhone() {
                Link(text, destination: URL(string: "phone:" + text)!)
                    .foregroundColor(.blue)
            } else {
                Text(text)
                    .foregroundColor(.white)
            }
        }
            
    }
}

// MARK: - ShowPhoto
/// Show Image in the bubble
struct ShowPhoto: View {
    @ObservedObject var vm: ChatsVM
    let message: Chat
    
    var body: some View {
        Button {
            vm.shouldShowPhoto = true
        } label: {
            if let photo = vm.downloadPhoto(message.photo!) {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 200, height: 200)
            } else {
                WebImage(url: URL(string: message.photo!))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 200, height: 200)
            }
        }
    }
}


// MARK: - ShowAudio
    /// Show audio in buble and enable play
struct ShowAudio: View {
    @ObservedObject var vm: ChatsVM
    @ObservedObject var vmAudio = AudioPlayer()
    @ObservedObject var timerManager = TimerManager()
    let message: Chat
    
    var body: some View {
        if vmAudio.isPlaying {
            Button {
                vmAudio.stopPlay()
                let _ = timerManager.stopTimer()
            } label: {
                Image(systemName: "stop.fill")
                Text(String(format: "%.1f", timerManager.secondsElapsed))
            }
        } else {
            Button {
                timerManager.startTimer()
                DispatchQueue.global(qos: .background).async {
                    if let audio = message.audio {
                        if let audioDownloaded = vm.downloadAudio(audio) {
                            vmAudio.playAudio(audioDownloaded)
                        }
                    }
                }
            } label: {
                Image(systemName: "play.fill")
                Text(String(describing: message.audio))
                if let audioTimer = message.audioTimer {
                    let trimedAudio = String(audioTimer).prefix(2)
                    Text(trimedAudio)
                }
            }
        }
    }
}



// MARK: - Preview
let data: [String: Any] = ["name": "Test"]
let userTest = User(data: data)

struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
        ChatView(chatUser: userTest)
            .previewDevice("iPhone 13 mini")
            .preferredColorScheme(.dark)
	}
}
