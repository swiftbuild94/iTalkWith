//
//  HistoryCell.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryCell: View {
    var contact: User
    var recentMessage: RecentMessage
    let shadowRadius: CGFloat = 5
    let circleLineWidth: CGFloat = 1
    let imageSize: CGFloat  = 72
    let spacing: CGFloat = 4
    let contactSize: CGFloat = 16
    let ageOfMessageSize: CGFloat = 14
    let imagePadding: CGFloat = 8
    let contactSpacing: CGFloat = 16
    let cornerRadius: CGFloat = 72
    
    var body: some View {
        return VStack {
                HStack(spacing: contactSpacing) {
                    if contact.profileImageURL != nil {
//                        Text(contact.profileImageURL ?? "Empty")
                        //Image(contact.profileImageURL ?? "")
                        WebImage(url: URL(string: contact.profileImageURL ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                            .cornerRadius(cornerRadius)
                            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color(.label), lineWidth: circleLineWidth)
                            )
                    }
//                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(contact.name)
                            //                            .font(.system(size: contactSize, weight: .bold))
                                .dynamicTypeSize(.large)
                            Spacer()
                            NotificationsView(notifications: 1)
                        }
                        HStack {
                            if recentMessage.audioTimer != nil {
                                Image(systemName: "mic")
                                Text(recentMessage.text!)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else if recentMessage.text == nil {
                                Image(systemName: "photo")
                                Text("Photo")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(recentMessage.text!)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(recentMessage.timeAgo)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }.padding(.horizontal)
                Spacer()
                Divider()
                    .padding(.vertical, imagePadding)
            }
    }
}


struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preferredColorScheme(.dark)
    }
}
