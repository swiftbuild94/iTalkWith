//
//  File.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 28/05/2022.
//

import SwiftUI

/// Shows Alerts
final class Alerts: ObservableObject {
    @Published var title = ""
    @Published var message = ""
    @Published var isAlert = false
    @Published var buttons = 1
    @Published var showCancel = false
    @Published var showDestructive = false
    @Published var defaultText = "Ok"
    @Published var destructiveText = "Destroy"
    @Published var buttonDefault = Alert.Button.default(Text("Ok"))
    @Published var buttonCancel = Alert.Button.cancel(Text("Cancel"))
//    @Published var buttonDestuctive = Alert.Button.destructive(Text("Destroy"))
    @Published var okHandler: (()->Void)?
//    @Published var cancelHandler: (()->Void)?
    @Published var destructiveHandler: (()->Void)?
    
    init() {
        self.okHandler = {
            print("Ok")
        }
        self.destructiveHandler = {
            print("Destroy")
        }
    }
}

