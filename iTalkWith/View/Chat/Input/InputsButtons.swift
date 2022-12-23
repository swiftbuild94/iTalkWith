//
//  InputsButtons.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct InputsButtons: View {
    // @State private var shouldShowImagePicker = false
    // @State private var shouldShowCamara = false
    // @State private var shouldShowContact = false
    // @State private var shouldShowLocation = false
    // @State private var shouldShowDocument = false
    // @State var typeOfContent: TypeOfContent
    @EnvironmentObject var vmChats: ChatsVM
    private let buttonsSize: CGFloat = 42
    
    var body: some View {
        HStack {
            Spacer()
            if vmChats.typeOfContent != .audio {
                Button {
                    vmChats.focus = false
                    vmChats.typeOfContent = .audio
                } label: {
                    Image(systemName: "mic.circle")
                }
            } else {
                Button {
                    vmChats.focus = true
                    vmChats.typeOfContent = .text
                } label: {
                    Image(systemName: "a.circle")
                }
            }
            Button {
                vmChats.shouldShowLocation = true
            } label: {
                Image(systemName: "location.circle")
            }
            /*
             Button {
                vmChats.shouldShowContact.toggle()
             } label: {
                Image(systemName: "person.crop.circle")
             }
             Button {
                vmChats.shouldShowGifPicker.toggle()
             } label: {
                Image(systemName: "gift.circle")
             }
             */
             Button {
                 vmChats.shouldShowCamara.toggle()
             } label: {
                Image(systemName: "camera.circle")
             }
            Button {
                vmChats.shouldShowImagePicker.toggle()
            } label: {
                Image(systemName: "photo.circle")
            }
            /* For Pro
            Button {
               // vmContacts.shouldShowProAdd = true
            } label: {
                Image(systemName: "flame.circle")
            }
             Button {
                vmChats.shouldShowDocument.toggle()
             } label: {
                Image(systemName: "doc.circle")
             }
            */
            Spacer()
        }
        .font(.system(size: buttonsSize))
    }
}
