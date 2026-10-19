//
//  AppLockSettings.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import CryptoKit

// PIN wird nur als Hash gespeichert
enum AppLockSettings {
    static let pinLength = 4

    private static let keyEnabled = "app_lock_enabled"
    private static let keyPinHash = "app_lock_pin_hash"
    private static let keyPinSalt = "app_lock_pin_salt"
    private static let keyBiometrics = "app_lock_biometrics"
    private static let keyTimeout = "app_lock_timeout"
    private static let hashRounds = 10_000
    private static var defaults: UserDefaults { .standard }

    static var enabled: Bool {
        defaults.bool(forKey: keyEnabled) && defaults.string(forKey: keyPinHash) != nil
    }

    static var biometricsEnabled: Bool {
        get { defaults.bool(forKey: keyBiometrics) }
        set { defaults.set(newValue, forKey: keyBiometrics) }
    }

    static var timeout: LockTimeout {
        get { LockTimeout(rawValue: defaults.string(forKey: keyTimeout) ?? "") ?? .oneMinute }
        set { defaults.set(newValue.rawValue, forKey: keyTimeout) }
    }

    // Neuer PIN schaltet die Sperre gleich mit ein
    static func setPin(_ pin: String) {
        let salt = hex((0..<16).map { _ in UInt8.random(in: 0...255) })
        defaults.set(salt, forKey: keyPinSalt)
        defaults.set(hashPin(pin, salt: salt), forKey: keyPinHash)
        defaults.set(true, forKey: keyEnabled)
    }

    static func checkPin(_ pin: String) -> Bool {
        guard let salt = defaults.string(forKey: keyPinSalt),
              let saved = defaults.string(forKey: keyPinHash) else { return false }
        return hashPin(pin, salt: salt) == saved
    }

    static func clear() {
        [keyEnabled, keyPinHash, keyPinSalt, keyBiometrics].forEach { defaults.removeObject(forKey: $0) }
    }

    // Mehrere Runden, damit der Hash nicht so leicht zu knacken ist
    private static func hashPin(_ pin: String, salt: String) -> String {
        var bytes = Data((salt + pin).utf8)
        for _ in 0..<hashRounds {
            bytes = Data(SHA256.hash(data: bytes))
        }
        return hex(Array(bytes))
    }

    private static func hex(_ bytes: [UInt8]) -> String {
        bytes.map { String(format: "%02x", $0) }.joined()
    }
}
