//
//  iTalk2App.swift
//  iTalk2
//
//  Created by Patricio Benavente on 29/11/2022.
//

import SwiftUI

@main
struct iTalk2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
