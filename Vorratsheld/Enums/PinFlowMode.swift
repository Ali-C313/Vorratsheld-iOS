//
//  PinFlowMode.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum PinFlowMode: Identifiable {
    case create, change, disable

    var id: Self { self }
}
