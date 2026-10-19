//
//  ProductRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol ProductRepository {
    func listenToProducts(userId: String, onChange: @escaping ([Product]) -> Void)
    func stopListening()

    // Ohne id neues Dokument, mit id wird überschrieben
    func saveProduct(_ product: Product) throws
    func updateFavorite(productId: String, isFavorite: Bool) async throws
    func deleteProduct(id: String) async throws
    func deleteAllProducts(userId: String) async throws
}
