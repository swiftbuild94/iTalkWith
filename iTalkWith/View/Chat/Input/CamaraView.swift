//
//  CamaraView.swift
//  iTalkWith
//
//  Created by Patricio Benavente on 01/01/2023.
//

import SwiftUI

struct CamaraView: View {
    @StateObject private var frameManager = FrameManager()
    
    
    var body: some View {
        FrameView(image: frameManager.frame)
            .ignoresSafeArea()
    }
}

struct CamaraView_Previews: PreviewProvider {
    static var previews: some View {
        CamaraView()
    }
}
