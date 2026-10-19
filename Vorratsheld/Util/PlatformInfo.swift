//
//  PlatformInfo.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import UIKit

enum PlatformInfo {
    static var platformName: String {
        UIDevice.current.systemName + " " + UIDevice.current.systemVersion
    }

    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}
