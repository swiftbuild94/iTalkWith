//
//  ChatsVM.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 14/02/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
//import FirebaseFirestoreSwift
//import FirebaseStorage
//import FirebaseStorageSwift
import SwiftUI
//import FirebaseStorage    

/// Just for inside the ChatView
///
/// Includes Downloading Photo, Audio, Send Message, Send Audio
///  and Save to Firebase
///  Used only in ChatView
final class ChatsVM: ObservableObject {
	@Published var chatText = ""
	@Published var errorMessage = ""
	@Published var chatMessages = [Chat]()
	@Published var count = 0
    @Published var chatUser: User?
    @Published var typeOfContent: TypeOfContent = .audio
    @Published var shouldShowImagePicker = false
    @Published var shouldShowCamara = false
    @Published var shouldShowContact = false
    @Published var shouldShowDocument = false
    @Published var shouldShowLocation = false
    @Published var shouldShowPhoto = false
    @Published var location: String?
    @Published var focus = false
    @Published var isShowAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var image: UIImage?
    @Published var data: Data?
    
    @State var bubbleColor: Color = Color.green
    
    private var url: URL?
    var audioTimer: Double?
    
    var firestoreListener: ListenerRegistration?
    
	init(chatUser: User?) {
		self.chatUser = chatUser
		fetchMessages()
        setBubbleColor()
	}
    
    deinit {
        firestoreListener?.remove()
    }
	
    private func setBubbleColor() {
        let storageBubble =  UserDefaults.standard.string(forKey: "bubbleColor")
        //print("storageBubble: \(String(describing: storageBubble) )")
        if storageBubble == "green" {
            self.bubbleColor = Color.green
        } else {
            self.bubbleColor = Color.blue
        }
    }
    
    
    // MARK: - Fetch Messages
    func getMessages() {
        DispatchQueue.main.async {
            self.fetchMessages()
        }
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        self.chatMessages.removeAll()
        self.firestoreListener?.remove()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp, descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print("Error listen message: \(error)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let chats = try change.document.data(as: Chat?.self) {
                                self.chatMessages.append(chats)
                            }
                            self.chatMessages.sort(by: { $0.timestamp < $1.timestamp })
                        } catch {
                            print("Catch Error: \(error)")
                        }
                    }
                })
            }
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    
    // MARK: - Download Photo
    func downloadPhoto(_ photo: String) -> UIImage? {
        var image: UIImage?
        print("===Photo")
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(photo)
        print("===Photo: \(photoRef.fullPath)")
        photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("====Error downloading \(error)")
            } else {
                image = UIImage(data: data!)
                print("====Image NOT Error: \(String(describing: data!))")
            }
        }
        print("====Image Returned===")
        return image
    }
    
    
    // MARK: - Download Audio
    func downloadAudio(_ audio: String) -> URL? {
        print("----DOWNLOAD AUDIO")
        //guard let uid = Auth.auth().currentUser?.uid else { return nil }
        print("---AUDIO DOWNLOADING: \(audio)" )
        let storageRef = Storage.storage()
        let audioRef = storageRef.reference(forURL: audio)
        let finalRef = audioRef.child(FirebaseConstants.audios)
        let fileName = URL(string: audio)?.pathComponents.last?.description
        print("----DOWNLOAD AUDIO -> FileName: \(String(describing: fileName))")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("----Filepath: \(String(describing: url))")
        let audioFileURL = url.appendingPathComponent(fileName ?? "")
        finalRef.write(toFile: audioFileURL) { audioUrl, error in
            if let err = error {
                print("----Error downloading audio: \(err)")
            } else {
                print("----Write Compleate: \(String(describing: audioUrl))")
            }
        }
        print("----Audio: \(String(describing: audioFileURL))")
        return audioFileURL
    }
    
    
    // MARK: - Send Message
    func handleSend(_ typeOfContent: TypeOfContent, data: [Any]? = nil) {
        switch typeOfContent {
        case .text:
            sendText()
        case .audio:
            persistAudioToStorage()
        case .photoalbum:
            persistImageToStorage()
        default:
            break
        }
    }

    private func sendText(){
        if chatText != "" {
            print("Send Text: \(chatText)")
            typeOfContent = .text
            sendToFirebase()
        }
    }
    
    // MARK: - PersistAudioToStorage
    private func persistAudioToStorage() {
        print("Saving Audio")
        var audios = [URL]()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryContents = try? fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents! {
            audios.append(audio)
        }
        guard let url = audios.last else { return }
        let metaData = StorageMetadata()
            metaData.contentType = "audio/m4a"
//      guard let audioData = try? Data(contentsOf: url) else { return }
        let ref = Storage.storage().reference()
        let audioRef = ref.child(FirebaseConstants.audios)
        let fileName = url.pathComponents.last?.description ?? ""
        //let fileName = String(UUID().description) + ".m4a"
        print("FileName: \(fileName)")
        let spaceRef = audioRef.child(fileName)
        spaceRef.putFile(from: url, metadata: metaData) { metadata, error in
            if let err = error {
                self.errorMessage = "Fail to save audio: \(err)"
                return
            }
            spaceRef.downloadURL { url, error in
                if let err = error {
                    self.errorMessage = "Fail to retrive downloadURL image: \(err)"
                    return
                }
                let downloadUrl = metadata?.path
                print("URL: \(downloadUrl!)")
                print("Success storing audio with URL: \(String(describing: url?.absoluteString))")
                guard let url = url else { return }
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("Can't delete")
                }
                self.typeOfContent = .audio
                self.sendToFirebase()
            }
        }
    }
    
    
    // MARK: - PersistImageToStorage
    private func persistImageToStorage() {
        print("Saving Image")
        //guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        let ref = Storage.storage().reference()
        let photoRef = ref.child(FirebaseConstants.photos)
        let fileName = String(UUID().description) + ".jpg"
        let spaceRef = photoRef.child(fileName)
        let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
        print("Full Path: \(ref.fullPath)")
        print("Name: \(ref.name)")
        spaceRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let err = error {
                self.errorMessage = "Fail to save image: \(err)"
                return
            }
            spaceRef.downloadURL { url, error in
                if let err = error {
                    self.errorMessage = "Fail to retrive downloadURL image: \(err)"
                    return
                }
                print("Success storing image with URL \(String(describing: url?.absoluteString))")
                guard let url = url else { return }
                self.url = url
                self.typeOfContent = .photoalbum
                self.sendToFirebase()
            }
        }
    }
    
    
    //    MARK: - Send To Firebase
	private func sendToFirebase() {
        var msg: Chat
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
		
		switch typeOfContent {
        case .text:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: self.chatText, photo: nil, audio: nil, audioTimer: nil, timestamp: Date())
        case .audio:
            let audio = Int(self.audioTimer!)
            let audioText = "Audio: \(String(describing: audio))"
            msg = Chat(id: nil, fromId: uid, toId: toId, text: audioText, photo: nil, audio: self.url?.absoluteString ?? "", audioTimer: self.audioTimer, timestamp: Date())
        case .photoalbum:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: nil, photo: self.url?.absoluteString ?? "", audio: nil, audioTimer: nil, timestamp: Date())
        default:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: nil, photo: nil, audio: self.url?.absoluteString ?? "", audioTimer: nil, timestamp: Date())
        }
        DispatchQueue.main.async {
            self.saveToMessagesAndRecentMessages(msg)
            self.chatText = ""
            self.getMessages()
            self.count += 1
        }
	}
	
	private func saveToMessagesAndRecentMessages(_ chat: Chat) {
//        print("----SaveToMessagesAndRecentMessages DATA: \(data)")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        var firebaseLocation = FirebaseDocument(
            firstCollection: FirebaseConstants.messages,
            firstDocument: uid,
            secondCollection: toId,
            secondDocument: nil)
 
		saveToFirebase(firebaseLocation, chat: chat)
		
		firebaseLocation.firstDocument = FirebaseConstants.messages
		firebaseLocation.firstDocument = toId
		firebaseLocation.secondCollection = uid
		saveToFirebase(firebaseLocation, chat: chat)
		
        var firebaseLocationRecent = FirebaseDocument(
            firstCollection: FirebaseConstants.recentMessages,
            firstDocument: uid,
            secondCollection: FirebaseConstants.messages,
            secondDocument: toId)
		saveToFirebase(firebaseLocationRecent, chat: chat)
		
		firebaseLocationRecent.firstDocument = FirebaseConstants.recentMessages
        firebaseLocationRecent.firstDocument = toId
        firebaseLocationRecent.secondCollection = FirebaseConstants.messages
        firebaseLocationRecent.secondDocument = uid
		saveToFirebase(firebaseLocationRecent, chat: chat)
	}
    
    
    // MARK: - Save to Firebase
    private func saveToFirebase(_ firebaseDocument: FirebaseDocument, chat: Chat) {
        print("Save to Firebase Document: \(firebaseDocument)")
        //print("Save to Firebase Data: \(chat)")
        let collection = firebaseDocument.firstCollection
        let document = firebaseDocument.firstDocument
        let secondCollection = firebaseDocument.secondCollection
        
        if firebaseDocument.secondDocument != nil {
            guard let secondDocument = firebaseDocument.secondDocument else { return }
            let document = FirebaseManager.shared.firestore
                .collection(collection)
                .document(document)
                .collection(secondCollection)
                .document(secondDocument)
            
            try? document.setData(from: chat) { error in
                if let error = error {
                    self.errorMessage = "Failed to save: \(error)"
                    print(self.errorMessage)
                    return
                }
            }
            print("Saved Messagge")
        } else {
            let document = FirebaseManager.shared.firestore
                .collection(collection)
                .document(document)
                .collection(secondCollection)
                .document()
            try? document.setData(from: chat) { error in
                if let error = error {
                    self.errorMessage = "Failed to save: \(error)"
                    print(self.errorMessage)
                    return
                }
            }
            print("Saved Messagge")
        }
    }
	
}
