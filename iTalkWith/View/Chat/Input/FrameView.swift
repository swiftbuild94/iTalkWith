//
//  FrameView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 01/01/2023.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("Frame")
     
    var body: some View {
        if let image = self.image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
