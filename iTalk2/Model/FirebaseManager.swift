//
//  FirebaseManager.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 4/12/21.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

/// For managing Firebase
final class FirebaseManager: NSObject {
	
	let auth: Auth
	let storage: Storage
	let firestore: Firestore
	
	static let shared = FirebaseManager()
	var firestoreListener: ListenerRegistration?
	
	override init() {
		FirebaseApp.configure()
		self.auth = Auth.auth()
		self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
		super.init()
	}
	
	// MARK: - Stop firestoreListener
	func stopFirestoreListener() {
		firestoreListener?.remove()
		print("FirestoreManger: firestoreListener removed")
	}
	
}
