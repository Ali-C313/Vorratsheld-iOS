//
//  ShoppingRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol ShoppingRepository {
    func listenToItems(userId: String, onChange: @escaping ([ShoppingItem]) -> Void)
    func stopListening()

    func addItem(_ item: ShoppingItem) throws
    func setChecked(itemId: String, checked: Bool) async throws
    func setQuantity(itemId: String, quantity: Int) async throws
    func deleteItem(id: String) async throws
    func deleteAllItems(userId: String) async throws

    // Steht der Artikel schon offen auf der Liste, wird nur die Menge erhöht
    func addFromProduct(_ product: Product) async throws
    // Gegenstück dazu, z. B. beim Rückgängigmachen
    func removeOneFromProduct(_ product: Product) async throws
}
