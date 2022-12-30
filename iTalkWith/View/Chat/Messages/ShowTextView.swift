//
//  ShowTextView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 23/12/2022.
//

import SwiftUI

/// Shows text in bubble if is url acts according
struct ShowTextView: View {
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

let showTextChat = Chat(id: "", fromId: "", toId: "", text: "text", photo: nil, audio: nil, audioTimer: nil, audioLocalURL: nil, timestamp: Date() )

struct ShowTextView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTextView(message: showTextChat)
    }
}
