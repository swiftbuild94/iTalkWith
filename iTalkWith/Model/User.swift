//
//  User.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 8/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var photo: String?
    var phoneNumber: String?
    var email: String?
    var profileImageURL: String?
    
    init(data: [String:Any]){
        self.uid = data[FirebaseConstants.uid] as? String ?? ""
        self.name = data[FirebaseConstants.name] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String
        self.photo = data[FirebaseConstants.photo] as? String
        self.profileImageURL = data[FirebaseConstants.profileImageUrl] as? String
        self.phoneNumber = data[FirebaseConstants.phone] as? String
    }
    
    // MARK: - Mutating User Func
//    mutating func changName(_ name: String){
//        self.name = name
//    }
//
//    mutating func changePhoto(_ photo: String){
//        self.photo = photo
//    }
//
//    mutating func changePhone(_ phone: String){
//        self.phoneNumber = phone
//    }
//
//    mutating func changeEmail(_ email: String){
//        self.email = email
//    }
    
//    // MARK: - Mutating Chat Func
//    mutating func addChat(_ chat: Chat){
//        self.chats.append(chat)
//    }
//
//    mutating func unreadChats(){
//        var count = 0
//        for chat in chats {
//            if chat.read == false {
//                count += 1
//            }
//        }
//        self.newChats = count
//    }
//
//    mutating func deliveredChat(_ id: UUID){
//        for var chat in chats {
//            if chat.id == id {
//                chat.delivered = true
//                removeChat(id: chat.id)
//                addChat(chat)
//            }
//        }
//    }
//
//    mutating func removeChat(id: UUID){
//        var index = 0
//        for chat in chats {
//            if chat.id == id {
//                self.chats.remove(at: index)
//            }
//            index += 1
//        }
//    }
}
