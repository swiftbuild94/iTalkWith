//
//  ShowPhotoView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

/// Show Image in the bubble
struct ShowPhotoView: View {
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


let showPhotoChat = Chat(id: "", fromId: "", toId: "", text: "text", photo: nil, audio: nil, audioTimer: nil, audioLocalURL: nil, timestamp: Date() )

struct ShowPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ShowPhotoView(message: showPhotoChat)
            .environmentObject(ChatsVM())
    }
}
