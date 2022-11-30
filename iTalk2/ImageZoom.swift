//
//  ImageZoom.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageZoom: View {
    @Environment(\.presentationMode) private var presentationMode
    var photo: String
    
    var body: some View {
        WebImage(url: URL(string: photo))
            .resizable()
            .scaledToFill()
            .clipped()
            .edgesIgnoringSafeArea(.all)
            .gesture(
                TapGesture()
                    .onEnded({ _ in
                        self.presentationMode.wrappedValue.dismiss()
                    })
            )
            .statusBar(hidden: true)
    }
}

struct ImageZoom_Previews: PreviewProvider {
    static var previews: some View {
        ImageZoom(photo: "SteveJobs")
    }
}
