//
//  PhotoView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoView: View {
    @Environment(\.presentationMode) private var presentationMode
    var photo: String
    var vmChat: ChatsVM
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: ImageZoom(photo: photo)) {
                WebImage(url: URL(string: photo))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .navigationTitle("Photo")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                vmChat.shouldShowPhoto = false
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                    }
            }
        }
    }
}
