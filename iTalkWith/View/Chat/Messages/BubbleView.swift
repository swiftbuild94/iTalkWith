//
//  BubbleView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI

/// Show text, photo, audio in buble
struct BubbleView: View {
    let message: Chat
    
    var body: some View {
        if message.photo != nil {
            ShowPhotoView(message: message)
        }
        if message.audio != nil {
            ShowAudioView(message: message)
        } else {
            ShowTextView(message: message)
        }
    }
}


let bubbleChat = Chat(id: "", fromId: "", toId: "", text: "text", photo: nil, audio: nil, audioTimer: nil, audioLocalURL: nil, timestamp: Date() )
struct Bubble_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(message: bubbleChat)
    }
}
