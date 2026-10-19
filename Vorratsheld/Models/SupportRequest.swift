//
//  SupportRequest.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

struct SupportRequest: Codable {
    var userId: String
    var replyEmail: String
    var category: SupportCategory
    var subject: String
    var message: String
    var platform: String
    var appVersion: String
    var createdAt: Int64
    var emailSent: Bool = false
}
