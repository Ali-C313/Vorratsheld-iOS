//
//  ProductInfoRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol ProductInfoRepository {
    // nil, wenn der Barcode nicht bekannt ist
    func fetchProductInfo(barcode: String) async throws -> ScannedProductInfo?
}
