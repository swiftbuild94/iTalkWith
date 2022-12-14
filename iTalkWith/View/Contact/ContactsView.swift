//
//  ContactsView.swift
//  iTalk
//
//  Created by Patricio Benavente on 26/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI	

struct ContactsView: View {
    @EnvironmentObject var vmContacts: ContactsVM
	@Environment(\.presentationMode) var presentationMode
	let didSelectNewUser: (User) -> ()
	
    var body: some View {
//		NavigationView {
			ScrollView {
				ForEach(vmContacts.users) { contact in
					Button {
						presentationMode.wrappedValue.dismiss()
						didSelectNewUser(contact)
					} label: {
						ContactCell(contact: contact)
					}
				}
			}
//		}
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.automatic)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarLeading) {
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Text("Cancel")
				}
			}
		}
	}
}



struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        iTalkView(userSelected: .constant(nil))
//		HistoryView()
//		ContactsView()
    }
}
