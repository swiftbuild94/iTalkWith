//
//  File.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 28/05/2022.
//

import SwiftUI

/// Shows Alerts
final class AlertsManager: ObservableObject {
    var title = ""
    var message = ""
    var isAlert = false
    var buttons = 1
    var showCancel = false
    var showDestructive = false
    var defaultText = "Ok"
    var destructiveText = "Destroy"
    var buttonDefault = Alert.Button.default(Text("Ok"))
    var buttonCancel = Alert.Button.cancel(Text("Cancel"))
//    @Published var buttonDestuctive = Alert.Button.destructive(Text("Destroy"))
    var okHandler: (()->Void)?
//    @Published var cancelHandler: (()->Void)?
    var destructiveHandler: (()->Void)?
    
    static let shared = AlertsManager()
    
    init() {
        self.okHandler = {
            print("Ok")
        }
        self.destructiveHandler = {
            print("Destroy")
        }
    }
}

