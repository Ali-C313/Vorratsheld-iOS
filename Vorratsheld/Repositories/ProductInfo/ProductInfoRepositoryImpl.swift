//
//  ProductInfoRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class ProductInfoRepositoryImpl: ProductInfoRepository {

    func fetchProductInfo(barcode: String) async throws -> ScannedProductInfo? {
        // Beispiel: https://world.openfoodfacts.org/api/v2/product/4008400301012.json
        let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode).json"
        let response: OpenFoodFactsResponse = try await WebService.shared.get(urlString: urlString)

        guard response.status == 1, let product = response.product else {
            return nil
        }
        return ScannedProductInfo(barcode: barcode, name: product.productName ?? "", imageUrl: product.imageUrl)
    }
}
