//
//  Route.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum Route: Hashable {
    case scan
    case settings
    case editProfile
    case language
    case help
    case securitySettings
    case legal(LegalType)
    // productId: zum Bearbeiten, barcode: neues Produkt direkt nach dem Scan
    case productDetail(productId: String = "", barcode: String = "")
    case productInfo(productId: String)
    case shoppingList
}

enum AuthRoute: Hashable {
    case register
}
