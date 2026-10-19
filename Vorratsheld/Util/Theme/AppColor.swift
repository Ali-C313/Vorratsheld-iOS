//
//  AppColor.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Farben wie in der Android-Version
enum AppColor {
    static let primary = Color.dynamic(light: 0x3F6B3F, dark: 0xA5D395)
    static let onPrimary = Color.dynamic(light: 0xFFFFFF, dark: 0x0F3D0F)
    static let primaryContainer = Color.dynamic(light: 0xC0EFB4, dark: 0x255128)
    static let onPrimaryContainer = Color.dynamic(light: 0x012201, dark: 0xC0EFB4)
    static let secondary = Color.dynamic(light: 0x8B5E34, dark: 0xFFB77C)
    static let secondaryContainer = Color.dynamic(light: 0xFFDCC0, dark: 0x693F12)
    static let onSecondaryContainer = Color.dynamic(light: 0x2D1600, dark: 0xFFDCC0)
    static let tertiary = Color.dynamic(light: 0x3A6470, dark: 0xA2CDDA)
    static let background = Color.dynamic(light: 0xFBFDF7, dark: 0x1A1C18)
    static let surface = Color.dynamic(light: 0xFBFDF7, dark: 0x1A1C18)
    static let onSurface = Color.dynamic(light: 0x1A1C18, dark: 0xE3E3DC)
    static let surfaceVariant = Color.dynamic(light: 0xDEE5D6, dark: 0x44483E)
    static let onSurfaceVariant = Color.dynamic(light: 0x424940, dark: 0xC2C9BC)
    static let surfaceContainerHigh = Color.dynamic(light: 0xE9ECE4, dark: 0x2A2D27)
    static let outline = Color.dynamic(light: 0x72796F, dark: 0x8C9388)
    static let outlineVariant = Color.dynamic(light: 0xC2C9BC, dark: 0x44483E)
    static let error = Color.dynamic(light: 0xBA1A1A, dark: 0xFFB4AB)
    static let errorContainer = Color.dynamic(light: 0xFFDAD6, dark: 0x93000A)
    static let onErrorContainer = Color.dynamic(light: 0x410002, dark: 0xFFDAD6)

    // Kopfbereiche, Sperrbildschirm, Splash
    static let cream = Color(hex: 0xFBF6EA)
    static let greenLight = Color(hex: 0x5E8C55)
    static let greenDark = Color(hex: 0x2F5530)
    static let headerGradient = LinearGradient(colors: [greenLight, greenDark], startPoint: .top, endPoint: .bottom)
    static let splashGreenLight = Color(hex: 0x5E8C55)
    static let splashGreen = Color(hex: 0x3F6B3F)
    static let splashGreenDark = Color(hex: 0x2A4A2B)

    // Ablauf-Farben
    static let warningContainer = Color(hex: 0xFFF3CD)
    static let onWarningContainer = Color(hex: 0x7A5B00)
    static let favorite = Color(hex: 0xFFA000)
    static let gold = Color(hex: 0xE8A93C)
    static let pinError = Color(hex: 0xFFB4AB)

    // Farben des App-Logos
    static let logoCapeRed = Color(hex: 0xB8432F)
    static let logoCapeShadow = Color(hex: 0x8F3122)
    static let logoLid = Color(hex: 0xC07A45)
    static let logoLidShadow = Color(hex: 0x8B5E34)
    static let logoNeck = Color(hex: 0xEADFC8)
    static let logoJar = Color(hex: 0xFBF6EA)
    static let logoLabel = Color(hex: 0xE3EFD9)
    static let logoStar = Color(hex: 0xE8A93C)
}
