//
//  NotificationsView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 17/07/2022.
//

import SwiftUI

struct NotificationsView: View {
    var notifications: Int
    
    var body: some View {
        Text(String(describing: notifications))
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .padding(.all, 7.0)
            .background(Color.red)
            .overlay(Circle().stroke(Color.black))
            .clipShape(Circle())
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(notifications: 8)
            .previewDevice("iPhone 13 mini")
            
    }
}
