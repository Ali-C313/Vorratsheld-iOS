//
//  ProductInfoRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class ProductInfoRepositoryMock: ProductInfoRepository {

    func fetchProductInfo(barcode: String) async throws -> ScannedProductInfo? {
        ScannedProductInfo(barcode: barcode, name: "Vollmilch 1L", imageUrl: nil)
    }
}
