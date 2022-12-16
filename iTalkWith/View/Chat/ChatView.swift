//
//  ChatView.swift
//  iTalk
//
//  Created by Patricio Benavente on 9/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import DSWaveformImage
import DSWaveformImageViews

struct ChatView: View {
    @Environment(\.presentationMode) var chatMode
    //    @ObservedObject private var vmLogin = LogInSignInVM()
//    @EnvironmentObject var vmChats: ChatsVM
    @EnvironmentObject var vmChats: ChatsVM
    @State private var zoomed = false
    //	@State private var typeOfContent: TypeOfContent = .text
    //    @State private var image: UIImage?
    @State private var shouldShowImagePicker = false
    @State private var shouldShowLocation = false
    @FocusState private var focus
    var contact: User?
    private let topPadding: CGFloat = 8
    //@ObservedObject private var vmContacts = ContactsVM()
    @ObservedObject var audioRecorder = AudioRecorder()
    private var isAllowedToRecord = false
    
    init(chatUser: User){
        self.contact = chatUser
        self.vmChats.setUser(chatUser: chatUser)
        self.focus = vmChats.focus
        isAllowedToRecord = self.audioRecorder.isAllowedToRecord()
    }
    
    var body: some View {
//        ActivityIndicator(isAnimating: $vmChat.isLoading) {
//            $0.style = .large
//            $0.hidesWhenStopped = true
//        }
        ZStack(alignment: .top) {
            VStack() {
                Divider()
                MessagesView()
                    .padding(.bottom, topPadding)
                InputsButtons()
                if vmChats.typeOfContent == .text {
                    ChatTextBar(vm: vmChats)
                } else if vmChats.typeOfContent == .audio {
                    ChatAudioBar()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)  {
                Text("Back")
                //                    Image(systemName: "phone.fill")
                //                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
                //                    Image(systemName: "video.fill")
                //                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
            }
            ToolbarItem(placement: .principal) {
                Button {
                    //                          chatMode.showUserDetails()
                } label: {
                    ContactImage(contact: contact!)
                    Text(contact!.name)
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
                ImagePicker(selectedImage: $vmChats.image, didSet: $shouldShowImagePicker)
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
    @EnvironmentObject var vmChat: ChatsVM
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
                        ForEach(vmChat.chatMessages) { message in
                            MessageView(message: message)
                        }
                        HStack { Spacer() }
                            .id(Self.bottomAnchor)
                    }
                    .onReceive(vmChat.$count) { _ in
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


// MARK: - MessageView
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
                        Bubble(message: message)
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
                        Bubble(message: message)
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
    let message: Chat
    
    var body: some View {
        if message.photo != nil {
            ShowPhoto(message: message)
        }
        if message.audio != nil {
            ShowAudio(message: message)
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
    @EnvironmentObject var vmChats: ChatsVM
    let message: Chat
    
    var body: some View {
        Button {
            vmChats.shouldShowPhoto = true
        } label: {
            if let photo = vmChats.downloadPhoto(message.photo!) {
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
    @EnvironmentObject var vmChats: ChatsVM
    @ObservedObject var vmAudio = AudioPlayer()
    @ObservedObject var timerManager = TimerManager()
    let message: Chat
    
    @State var waveformConfiguration: Waveform.Configuration = Waveform.Configuration(
        size: CGSize(width: 80, height: 30),
        backgroundColor: .blue,
        style: .filled(.white),
        dampening: .none,
        position: .middle,
        scale: 1,
        verticalScalingFactor: 1,
        shouldAntialias: true
        )
    
    var body: some View {
        if vmAudio.isPlaying {
            Button {
                DispatchQueue.global(qos: .userInteractive).async {
                    vmAudio.stopPlay()
                }
                let _ = timerManager.stopTimer()
            } label: {
//                if vm.audioURL != nil {
//                    WaveformView(audioURL: vm.audioURL!, configuration: waveformConfiguration, priority: .medium)
//                }
                Image(systemName: "stop.fill")
                Text(String(format: "%.1f", timerManager.secondsElapsed))
            }
        } else {
            Button {
                timerManager.startTimer()
                //DispatchQueue.global(qos: .userInteractive).async {
                    if let audio = message.audio {
                        if let audioDownloaded = vmChats.downloadAudio(audio) {
                            vmAudio.playAudio(audioDownloaded)
                        }
                    }
                //}
            } label: {
                Image(systemName: "play.fill")
//                if let audio = vm.audioURL {
//                    WaveformView(audioURL: audio, configuration: waveformConfiguration, priority: .medium)
//                        Text(String(describing: audio))
//                }
                Text(message.audio ?? "")
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
            .previewDevice("iPhone 14 Pro")
            //.preferredColorScheme(.dark)
    }
}
