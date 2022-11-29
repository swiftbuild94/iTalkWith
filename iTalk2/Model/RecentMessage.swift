//
//  RecentMessage.swift
//  iTalk Chat
//
//  Created bxy Patricio Benavente on 16/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let fromId, toId: String
    let text: String?
    let audioTimer: Double?
    let photo: String?
    let timestamp: Date
    var timeAgo: String {
        let formater = RelativeDateTimeFormatter()
        formater.unitsStyle = .abbreviated
        return formater.localizedString(for: timestamp, relativeTo: Date())
    }
    /*
    init(data: [String:Any]){
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.audioTimer = data[FirebaseConstants.audioTimer] as? Double
        self.photo = data[FirebaseConstants.photo] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? Date ?? Date()
    }
     */
}
