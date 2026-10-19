//
//  OpenFoodFactsResponse.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

struct OpenFoodFactsResponse: Codable {
    let status: Int
    let product: OpenFoodFactsProduct?
}

struct OpenFoodFactsProduct: Codable {
    let productName: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case imageUrl = "image_url"
    }
}
