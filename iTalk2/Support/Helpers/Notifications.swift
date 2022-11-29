//
//  Notifications.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 30/05/2022.
//

import NotificationCenter
import UserNotifications

/// Manage the Notifications
final class NotificationManager: ObservableObject {
    var notifications = [Notification]()
    
    init() {
        notificationsAllowed()
    }
    
    func notificationsAllowed() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notifications Error: \(error)")
            }
            if granted == true {
                print("Allowed Notifications")
                // Enable or disable features based on the authorization.
            }
        }
    }
    
    func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double, badge: Int = 0) {
        print("Badge: \(badge)")
        if badge > 0 {
                UIApplication.shared.applicationIconBadgeNumber = badge
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1)
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.interruptionLevel = .timeSensitive
        let imageName = "iTalk"
        guard let imageUrl = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageUrl, options: .none)
        content.attachments = [attachment]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("NOTIFICATION: Error")
            }
        }
    }
}


/*
public protocol UNNotificationContentProviding: NSObjectProtocol {}

extension UNNotificationServiceExtension {
    
    func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let incomingMessageIntent: INSendMessageIntent = ""
        let interaction = INIteration(intent: incomingMessageIntent, response: nil)
            interaction.direction = .incoming
            interaction.donate(completion: nil)
        do {
            let messageContent = try request.content.updating(from: incomingMessageIntent)
        } catch {
            print("Notification Error: \(error)")
        }
    }
}
*/
