//
//  ShoppingRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class ShoppingRepositoryMock: ShoppingRepository {

    private var onChange: (([ShoppingItem]) -> Void)?

    private var items: [ShoppingItem] = {
        var eggs = ShoppingItem(userId: "preview", name: "Eier", quantity: 10, addedAt: 1)
        eggs.id = "1"
        var bread = ShoppingItem(userId: "preview", name: "Brot", addedAt: 2)
        bread.id = "2"
        var cheese = ShoppingItem(userId: "preview", name: "Käse", checked: true, addedAt: 3)
        cheese.id = "3"
        return [eggs, bread, cheese]
    }()

    func listenToItems(userId: String, onChange: @escaping ([ShoppingItem]) -> Void) {
        self.onChange = onChange
        onChange(items)
    }

    func stopListening() {
        onChange = nil
    }

    func addItem(_ item: ShoppingItem) throws {
        var saved = item
        saved.id = UUID().uuidString
        items.append(saved)
        onChange?(items)
    }

    func setChecked(itemId: String, checked: Bool) async throws {
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            items[index].checked = checked
        }
        onChange?(items)
    }

    func setQuantity(itemId: String, quantity: Int) async throws {
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            items[index].quantity = quantity
        }
        onChange?(items)
    }

    func deleteItem(id: String) async throws {
        items.removeAll { $0.id == id }
        onChange?(items)
    }

    func deleteAllItems(userId: String) async throws {
        items.removeAll()
        onChange?(items)
    }

    func addFromProduct(_ product: Product) async throws {
        try addItem(ShoppingItem(userId: product.userId, name: product.name))
    }

    func removeOneFromProduct(_ product: Product) async throws {}
}
