//
//  Chat.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    let fromId: String
    let toId: String?
//    let typeOfContent: TypeOfContent
    let text: String?
//    let video: Data?
//    let videDuration: String?
//    let location: String?
    let photo: String?
    let audio: String?
    let audioTimer: Double?
//    let readtime: Date?
    let timestamp: Date
//    var timeAgo: String {
//        let formater = RelativeDateTimeFormatter()
//        formater.unitsStyle = .abbreviated
//        return formater.localizedString(for: timestamp, relativeTo: Date())
//    }
}
