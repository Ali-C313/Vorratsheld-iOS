//
//  ProductViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class ProductViewModel {

    private let productRepository: ProductRepository
    private let shoppingRepository: ShoppingRepository
    private let authRepository: AuthRepository

    var products: [Product] = []
    var errorMessage: String?

    init(productRepository: ProductRepository, shoppingRepository: ShoppingRepository, authRepository: AuthRepository) {
        self.productRepository = productRepository
        self.shoppingRepository = shoppingRepository
        self.authRepository = authRepository
    }

    func fetchProducts() {
        guard let userId = authRepository.currentUserId else { return }
        productRepository.listenToProducts(userId: userId) { products in
            self.products = products
            // Erinnerungen bei jeder Änderung neu einplanen
            NotificationManager.shared.scheduleExpiryReminders(for: products)
        }
    }

    func stopListening() {
        productRepository.stopListening()
        products = []
    }

    func product(withId id: String) -> Product? {
        products.first { $0.id == id }
    }

    func saveProduct(_ product: Product) {
        do {
            try productRepository.saveProduct(product)
        } catch {
            errorMessage = S.errorSaveFailed(error.localizedDescription)
        }
    }

    func toggleFavorite(_ product: Product) {
        guard let productId = product.id else { return }
        Task {
            do {
                try await productRepository.updateFavorite(productId: productId, isFavorite: !product.isFavorite)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // Favoriten wandern beim Löschen auf die Einkaufsliste
    func deleteProduct(_ product: Product) {
        guard let productId = product.id else { return }
        Task {
            do {
                try await productRepository.deleteProduct(id: productId)
                if product.isFavorite {
                    try await shoppingRepository.addFromProduct(product)
                }
            } catch {
                errorMessage = S.errorDeleteFailed(error.localizedDescription)
            }
        }
    }

    // Rückgängig: Dokument mit derselben ID wieder anlegen
    func restoreProduct(_ product: Product) {
        saveProduct(product)
        guard product.isFavorite else { return }
        Task {
            do {
                try await shoppingRepository.removeOneFromProduct(product)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func addToShoppingList(_ product: Product, onAdded: @escaping () -> Void) {
        Task {
            do {
                try await shoppingRepository.addFromProduct(product)
                onAdded()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
