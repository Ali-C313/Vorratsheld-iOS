//
//  BiometricHelper.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum BiometricHelper {
    static func label(_ type: BiometricType) -> String {
        switch type {
        case .faceId: return S.biometricFaceId
        case .touchId: return S.biometricTouchId
        default: return S.biometricGeneric
        }
    }

    static func icon(_ type: BiometricType) -> String {
        switch type {
        case .faceId: return "faceid"
        case .touchId: return "touchid"
        default: return "lock.shield"
        }
    }
}
