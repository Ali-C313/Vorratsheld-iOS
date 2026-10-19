//
//  NotificationManager.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import UserNotifications

// Erinnerung um 9 Uhr, 3 Tage vor Ablauf
class NotificationManager {

    static let shared: NotificationManager = NotificationManager()

    private init() {}

    func scheduleExpiryReminders(for products: [Product]) {
        let center = UNUserNotificationCenter.current()
        let title = S.reminderTitle
        let reminders: [(id: String, body: String, expiryDate: Int64)] = products.compactMap { product in
            product.id.map { (id: $0, body: S.reminderBody(product.name), expiryDate: product.expiryDate) }
        }

        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error {
                print(error)
            }
            guard granted else {
                print("Benachrichtigungen wurden abgelehnt und können nicht gesendet werden.")
                return
            }
            // Alte Erinnerungen löschen, sonst kommen auch welche für gelöschte Produkte
            center.removeAllPendingNotificationRequests()
            let today = LocalDay.today()

            for reminder in reminders {
                let reminderDay = DateHelper.expiryDateToLocalDay(reminder.expiryDate).adding(days: -3)
                // Sieht man dann eh in der App
                if reminderDay <= today { continue }

                let content = UNMutableNotificationContent()
                content.title = title
                content.body = reminder.body
                content.sound = .default

                var components = DateComponents()
                components.year = reminderDay.year
                components.month = reminderDay.month
                components.day = reminderDay.day
                components.hour = 9

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
                center.add(request) { error in
                    if let error {
                        print("Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
