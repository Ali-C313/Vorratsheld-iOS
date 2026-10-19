//
//  SupportViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class SupportViewModel {

    private let supportRepository: SupportRepository
    private let authRepository: AuthRepository

    var category: SupportCategory = .problem
    var subject = ""
    var message = ""
    var replyEmail = ""
    var isSending = false
    var isSent = false
    var errorMessage: String?

    init(supportRepository: SupportRepository, authRepository: AuthRepository) {
        self.supportRepository = supportRepository
        self.authRepository = authRepository
        replyEmail = authRepository.currentEmail
    }

    func send() {
        let trimmedSubject = subject.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSubject.isEmpty, !trimmedMessage.isEmpty else {
            errorMessage = S.helpErrorEmpty
            return
        }

        let request = SupportRequest(
            userId: authRepository.currentUserId ?? "",
            replyEmail: replyEmail.trimmingCharacters(in: .whitespaces),
            category: category,
            subject: trimmedSubject,
            message: trimmedMessage,
            platform: PlatformInfo.platformName,
            appVersion: PlatformInfo.appVersion,
            createdAt: DateHelper.nowMillis()
        )

        isSending = true
        Task {
            do {
                try await supportRepository.send(request)
                subject = ""
                message = ""
                isSent = true
            } catch {
                errorMessage = S.helpErrorSend(error.localizedDescription)
            }
            isSending = false
        }
    }
}
