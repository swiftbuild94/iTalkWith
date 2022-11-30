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
    @ObservedObject private var vmLogin = LogInSignInVM()
//    @ObservedObject private var vmContacts = ContactsVM()
    @State var shouldShowLogOutOptions = true
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    @State private var isAutoPlayAudio = true
    @State private var isAutoRecordAudio = true
//    @State var currentUser: User?
    let colorBubles = true
    
    let optionsSize: CGFloat = 16
    
    var body: some View {
        NavigationView {
            Form {
//                userInfo(currentUser: vmContacts.myUser)
                HStack {
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                           Image(vmLogin.myUser?.profileImageURL ?? "")
                            WebImage(url: URL(string: vmLogin.myUser?.profileImageURL ?? "" ))
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
                        Text(vmLogin.myUser?.name ?? "")
                            .font(.system(size: 24, weight: .bold))
                        Text(vmLogin.myUser?.phoneNumber ?? "")
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
                Picker(selection: $vmLogin.bubbleColor, label: Text("Bubbles Color")) {
                    Text("Blue")
                        .tag(BubbleColors.blue)
                    Text("Green")
                        .tag(BubbleColors.green)
                }.pickerStyle(InlinePickerStyle())
                    .onChange(of: vmLogin.bubbleColor) { tag in
                        switch tag {
                        case .blue:
                            UserDefaults.standard.set("blue", forKey: "bubbleColor")
                        case .green:
                            UserDefaults.standard.set("green", forKey: "bubbleColor")
                        }
                        
                    }
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
                Button {
                    vmLogin.shouldShowLogOutOptions.toggle()
                } label: {
                    Text("Log Out")
                        .font(.system(size: optionsSize, weight: .bold))
                        .foregroundColor(Color.red)
                }
            }
            //            .padding()
            .actionSheet(isPresented: $vmLogin.shouldShowLogOutOptions) {
                .init(title: Text("Log Out"), message: Text("Are you sure you want to Log Out"), buttons: [
                        .destructive(Text("Log Out"), action: {
                           vmLogin.handleSignOut()
                        }),
                        .cancel()
                ])
            }
            .navigationBarTitle(Text("Settings"))
        }
//        .fullScreenCover(isPresented: vm.$shouldShowImagePicker, onDismiss: nil) {
//            ImagePicker(selectedImage: vm.$image, didSet: vm.$shouldShowImagePicker)
//        }
     

//}
    }    
}

struct userInfo: View {
    let shadowRadius: CGFloat = 15
    let circleLineWidth: CGFloat = 1
    let imageSize: CGFloat  = 52
    let spacing: CGFloat = 4
    let usernameSize: CGFloat = 16
    let onlineCircleSize: CGFloat = 14
    let hstackSpacing: CGFloat = 16
    var currentUser: User?
    @State private var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: hstackSpacing) {
                   /* Text((currentUser?.photo)!)
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        WebImage(url: URL(string: (currentUser?.photo)!))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(imageSize)
                                .frame(width: imageSize, height: imageSize)
                    }
                    .clipShape(Circle())
                        .shadow(radius: shadowRadius)
                        .overlay(Circle().stroke(Color.blue, lineWidth: circleLineWidth))
                    Spacer()
                    */
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentUser?.name ?? "Name not Registered")
                            .font(.system(size: usernameSize, weight: .bold))
                        HStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: onlineCircleSize, height: onlineCircleSize)
                            Text("online")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    Divider()
                }.padding(.horizontal)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
