//
//  LogInSignInVM.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import SwiftUI

/// For LogIn and SignIn
final class LogInSignInVM: ObservableObject {
	@Published var isLoginMode = true
	@Published var isUserLoggedOut = false
	@Published var name = ""
	@Published var email = ""
	@Published var password = ""
	@Published var passwordRetype = ""
	@Published var phoneNumber = ""
	@Published var errorMessage = " "
	@Published var image: UIImage?
    @Published var myUser: User?
    @Published var myUserUid = ""
    @Published var myUserName = ""
    @Published var myUserPhoto = ""
	@Published var shouldShowLogOutOptions = false
    @Published var bubbleColor: BubbleColors = .green
//    @Published var didCompleateLoginProcess = (() -> ()).self
//    var didCompleateLoginProcess: () -> ()

    var selectedUser: String?
    
    init() {
        getCurrentUser()
    }
    
    
//    MARK: - Get Current User
    func getCurrentUser() {
//        print("CheckCurrentUser")
        DispatchQueue.main.async {
            if FirebaseManager.shared.auth.currentUser?.uid == nil {
                self.isUserLoggedOut = true
            } else {
                self.isUserLoggedOut = false
                self.selectedUser = FirebaseManager.shared.auth.currentUser?.uid
                self.fethCurrentUser(self.selectedUser!)
            }
        }
    }
    
    private func fethCurrentUser(_ uid: String) {
//        print("Fetch Current User: \(uid)")
//        let name = FirebaseManager.shared.auth.currentUser?.name
//        currentUser = User(uid: uid, name: name)
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { [self] snapshot, error in
            if let err = error {
                self.errorMessage = "Failed getting current user: \(err)"
                print(self.errorMessage)
                return
            }
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                print(self.errorMessage)
                return
            }
            self.myUser = User(data: data)
//            self.errorMessage = String(describing: data)
            self.myUserName = self.myUser?.name ?? ""
            self.myUserPhoto = self.myUser?.profileImageURL ?? ""
//            print("Current User: \(String(describing: self.myUser!))")
        }
    }
	
	
	// MARK: - LogIn User
    func loginUser() {
        print("loginUser")
		FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
			if let error = error {
				self.errorMessage = "Failed to login user: \(error)"
				return
			}
            self.isUserLoggedOut = false
			print("Succefully login user:  \(result?.user.uid ?? "")")
//			self.didCompleateLoginProcess()
            print("VCisUserLoggedOut: \(self.isUserLoggedOut)")
            return
		}
	}
	
	// MARK: - Create Account
	func createAccount() {
        if self.image == nil {
            self.errorMessage = "You must select an image"
            return
        }
        if ((name != "") && (email != "") && (password != "")) {
			if (password == passwordRetype) {
                print("Name: \(name)")
				FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
					if let error = error {
						self.errorMessage = "Failed to create user: \(error)"
						return
					}
                    
					print("Succefully created user:  \(result?.user.uid ?? "")")
                    self.persistImageToStorage()
				}
			} else {
				self.errorMessage = "Passwords do not match"
			}
        } else {
            self.errorMessage = "Please fill all data"
        }
	}
	
	func persistImageToStorage() {
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
		let fileName = uid + ".jpg"
        let storageRef = FirebaseManager.shared.storage.reference()
        let photoRef = storageRef.child(FirebaseConstants.users)
        let userRef = photoRef.child(fileName)
		//let ref = FirebaseManager.shared.storage.reference(withPath: fileName)
		guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
		userRef.putData(imageData, metadata: nil) { metadata, error in
			if let err = error {
				self.errorMessage = "Fail to save image: \(err)"
				return
			}
            userRef.downloadURL { url, error in
				if let err = error {
					self.errorMessage = "Fail to retrive downloadURL image: \(err)"
					return
				}
				print("Success storing image with URL \(String(describing: url?.absoluteString))")
				guard let url = url else { return }
				self.storeUserInformation(url)
			}
		}
	}
	   
	private func storeUserInformation(_ imageURL: URL? = nil) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let image = imageURL else { return }
        
        let userData: [String : Any] = [FirebaseConstants.uid: uid,
                            FirebaseConstants.name: self.name,
                            FirebaseConstants.email: self.email,
                            FirebaseConstants.phone: self.phoneNumber,
                            FirebaseConstants.profileImageUrl:  image.absoluteString]
//        print(userData)
		FirebaseManager.shared.firestore.collection("users")
			.document(uid).setData(userData) { error in
				if let err = error {
					self.errorMessage = "Error: \(err)"
                    print(self.errorMessage)
					return
				}
				print("Success saving User")
                DispatchQueue.main.async {
                    self.isUserLoggedOut = false
                }
                
//				self.didCompleateLoginProcess()
			}
	}
	
	
	// MARK: - SignOut
	 func handleSignOut() {
         DispatchQueue.main.async {
             self.isUserLoggedOut = true
         }
		try? FirebaseManager.shared.auth.signOut()
         print("Logged Out!")
	}
}
