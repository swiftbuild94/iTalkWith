//
//  MainView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import SwiftUI

struct ContentView: View {
    //@AppStorage("appColor", store: .standard) var appSorage = "blue"
    @StateObject var vmLogin = LogInSignInVM()
    @StateObject var vmContacts = ContactsVM()
    //@StateObject var vmChats = ChatsVM()
    @StateObject var vmIconNames = IconNames()
    // @StateObject private var vmAlerts = Alerts()
    // @State var isUserLoggedOut = false
    @State private var selection = 0
    @State private var isShowChat = false
    @State private var userSelected: User?
    
    var body: some View {
        TabView(selection: $selection){
            iTalkView(userSelected: $userSelected)
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("iTalkWith")
                    }
            }
            .tag(0)
            /*
             HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
            }
            .tag(1)
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Stories")
                    }
            }
            .tag(3)
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.2.fill")
                        Text("Meet")
                    }
            }
            .tag(4)
             */
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .tag(2)
        }
        .fullScreenCover(isPresented: $vmLogin.isUserLoggedOut) {
            LogInView(isUserLoggedOut: self.$vmLogin.isUserLoggedOut, didCompleateLoginProcess: {
                self.vmLogin.isUserLoggedOut = false
                self.vmLogin.getCurrentUser()
                self.vmContacts.getAllUsers()
                self.vmContacts.getRecentMessagges()
            })
        }
        .sheet(item: $userSelected, onDismiss: {
            //vmContacts.getAllUsers()
            //vmContacts.getRecentMessagges()
            //vmChats.firestoreListener?.remove()
            userSelected = nil
        }) { _ in
            VStack {
                NavigationView {
                    if let userSelected {
                        ChatView(contact: userSelected)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            //vmChat.shouldShowLocation = false
                            // self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
        /*
        .alert(isPresented: AlertsManager.shared.$isAlert) {
            if AlertsManager.shared.showCancel {
                let defaultButton = Alert.Button.default(Text(AlertsManager.shared.defaultText)) {
                    AlertsManager.shared.okHandler!()
                }
                return Alert(title: Text(AlertsManager.shared.title), message: Text(AlertsManager.shared.message), primaryButton: AlertsManager.shared.buttonCancel, secondaryButton: defaultButton)
                
            } else if AlertsManager.shared.showDestructive {
                let destructiveButton = Alert.Button.destructive(Text(AlertsManager.shared.defaultText)) {
                    AlertsManager.shared.destructiveHandler!()
                }
                return Alert(title: Text(AlertsManager.shared.title), message: Text(AlertsManager.shared.message), primaryButton: AlertsManager.shared.buttonCancel, secondaryButton: destructiveButton)
            } else {
                return Alert(title: Text(AlertsManager.shared.title), message: Text(AlertsManager.shared.message), dismissButton: AlertsManager.shared.buttonDefault)
            }
        }
         */
        .environmentObject(vmLogin)
        .environmentObject(vmContacts)
        .environmentObject(vmIconNames)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 14 Pro")
        }
    }
}
