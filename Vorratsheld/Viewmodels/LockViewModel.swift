//
//  LockViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import Observation
import LocalAuthentication

@MainActor
@Observable
class LockViewModel {

    // Beim Start gesperrt, wenn die Sperre eingeschaltet ist
    var isLocked = AppLockSettings.enabled
    var errorMessage: String?

    @ObservationIgnored private var backgroundSince: Date?

    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .unavailable
        }
        switch context.biometryType {
        case .faceID: return .faceId
        case .touchID: return .touchId
        default: return .generic
        }
    }

    func onBackground() {
        backgroundSince = Date()
    }

    // Nach der eingestellten Zeit im Hintergrund wieder sperren
    func onForeground() {
        guard let since = backgroundSince else { return }
        backgroundSince = nil
        guard AppLockSettings.enabled else { return }
        let timeout = AppLockSettings.timeout
        if timeout != .onStartOnly && Date().timeIntervalSince(since) >= Double(timeout.seconds) {
            isLocked = true
        }
    }

    func unlock() {
        isLocked = false
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        // Erscheint nach einem Fehlversuch
        context.localizedFallbackTitle = S.lockUsePin
        errorMessage = nil

        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: S.lockBiometricReason)
        } catch {
            switch error {
            case LAError.userCancel, LAError.systemCancel, LAError.userFallback:
                errorMessage = nil
            case LAError.biometryNotEnrolled:
                errorMessage = S.applockNoBiometrics
            default:
                errorMessage = error.localizedDescription
            }
            return false
        }
    }
}
