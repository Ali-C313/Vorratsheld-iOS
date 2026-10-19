//
//  EmailJsRequest.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

struct EmailJsRequest: Codable {
    let serviceId: String
    let templateId: String
    let publicKey: String
    let accessToken: String
    let templateParams: [String: String]

    enum CodingKeys: String, CodingKey {
        case serviceId = "service_id"
        case templateId = "template_id"
        case publicKey = "user_id"
        case accessToken
        case templateParams = "template_params"
    }
}
