//
//  SupportRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import FirebaseFirestore

class SupportRepositoryImpl: SupportRepository {

    private let database = FirebaseManager.shared.database

    func send(_ request: SupportRequest) async throws {
        var saved = request
        // Auch wenn die Mail nicht klappt, wird die Anfrage gespeichert
        saved.emailSent = await sendMail(for: request)
        try database.collection(CollectionNames.supportRequests).addDocument(from: saved)
    }

    private func sendMail(for request: SupportRequest) async -> Bool {
        guard Secrets.isEmailJsConfigured else { return false }
        let body = EmailJsRequest(
            serviceId: Secrets.emailJsServiceId,
            templateId: Secrets.emailJsTemplateId,
            publicKey: Secrets.emailJsPublicKey,
            accessToken: Secrets.emailJsPrivateKey,
            templateParams: [
                "category": request.category.rawValue,
                "subject": request.subject,
                "message": request.message,
                "reply_to": request.replyEmail,
                "user_id": request.userId,
                "platform": request.platform,
                "app_version": request.appVersion
            ]
        )
        do {
            try await WebService.shared.post(urlString: "https://api.emailjs.com/api/v1.0/email/send", body: body)
            return true
        } catch {
            print("EmailJS: \(error.localizedDescription)")
            return false
        }
    }
}
