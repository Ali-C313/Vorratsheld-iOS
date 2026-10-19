//
//  ProductDetailViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class ProductDetailViewModel {

    private let productInfoRepository: ProductInfoRepository

    var name = ""
    var location: StorageLocation = .kuehlschrank
    var expiryDate: Int64 = LocalDay.today().adding(days: 7).millis   // Standard: in einer Woche
    var quantity = 1
    var isFavorite = false
    var isLoading = false
    var errorMessage: String?

    private var productId: String?
    private var barcode = ""
    private var imageUrl: String?
    private var addedAt = DateHelper.nowMillis()

    var isEditMode: Bool {
        productId != nil
    }

    init(productInfoRepository: ProductInfoRepository) {
        self.productInfoRepository = productInfoRepository
    }

    // Name und Bild kommen von Open Food Facts
    func loadForNewScan(barcode: String) {
        self.barcode = barcode
        isLoading = true
        Task {
            do {
                let info = try await productInfoRepository.fetchProductInfo(barcode: barcode)
                name = info?.name ?? ""
                imageUrl = info?.imageUrl
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }

    func load(_ product: Product) {
        productId = product.id
        barcode = product.barcode
        name = product.name
        imageUrl = product.imageUrl
        location = product.location
        expiryDate = product.expiryDate
        quantity = product.quantity
        isFavorite = product.isFavorite
        addedAt = product.addedAt
    }

    func changeQuantity(by delta: Int) {
        quantity = min(max(quantity + delta, 1), 99)
    }

    func makeProduct(userId: String) -> Product {
        var product = Product(
            userId: userId,
            barcode: barcode,
            name: name.trimmingCharacters(in: .whitespaces),
            imageUrl: imageUrl,
            location: location,
            expiryDate: expiryDate,
            quantity: quantity,
            isFavorite: isFavorite,
            addedAt: addedAt
        )
        product.id = productId
        return product
    }
}
