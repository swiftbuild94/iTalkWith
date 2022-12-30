//
//  SettingsView.swift
//  iTalk
//
//  Created by Patricio Benavente on 25/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingsView: View {
    @EnvironmentObject var vmLogin: LogInSignInVM
    @EnvironmentObject var vmIconNames: IconNames
    //    @EnvironmentObject var vmChats: ChatsVM
    
    @State var shouldShowLogOutOptions = true
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    @State var bubbleColor: BubbleColors = .blue
    
    let optionsSize: CGFloat = 16
    
    init() {
        let bubble = UserDefaults.standard.string(forKey: "bubbleColor")
        if bubble == "green" {
            bubbleColor = .green
        } else {
            bubbleColor = .blue
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if let user = vmLogin.myUser {
                    UserInfo(shouldShowImagePicker: $shouldShowImagePicker, user: user)
                }
                Picker(selection: $bubbleColor, label: Text("Bubbles Color")) {
                    Text("Blue")
                        .tag(BubbleColors.blue)
                    Text("Green")
                        .tag(BubbleColors.green)
                }
                .pickerStyle(InlinePickerStyle())
                .onChange(of: bubbleColor) { tag in
                    vmLogin.setBubbleColor(bubbleColor: tag)
                }
                Toggles()
                Button {
                    vmLogin.shouldShowLogOutOptions.toggle()
                } label: {
                    Text("Log Out")
                        .font(.system(size: optionsSize, weight: .bold))
                        .foregroundColor(Color.red)
                }
            }
            .navigationBarTitle(Text("Settings"))
            .actionSheet(isPresented: $vmLogin.shouldShowLogOutOptions) {
                .init(title: Text("Log Out"), message: Text("Are you sure you want to Log Out"), buttons: [
                    .destructive(Text("Log Out"), action: {
                        vmLogin.handleSignOut()
                    }),
                    .cancel()
                ])
            }
        }
    }
}

struct Toggles: View {
    @State private var isAutoPlayAudio = true
    @State private var isAutoRecordAudio = true
    
    var body: some View {
        Section {
            Text("Chat Background")
            Toggle("Auto play audio message", isOn: $isAutoPlayAudio)
            Toggle("Auto record audio message", isOn: $isAutoRecordAudio)
        }
        Section {
            Text("Story")
            Text("Notifications")
            Text("Security")
        }
        Section {
            Text("Archived Users")
            Text("Blocked Users")
        }
    }
}
 

struct UserInfo: View {
    @Binding var shouldShowImagePicker: Bool
    var user: User
    var body: some View {
        HStack {
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                Image(user.profileImageURL ?? "")
                WebImage(url: URL(string: user.profileImageURL ?? "" ))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(82)
                    .frame(width: 82, height: 82)
            }
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 24, weight: .bold))
                Text((user.phoneNumber ?? user.email)!)
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                Spacer()
            }
            Spacer()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LogInSignInVM())
    }
}
