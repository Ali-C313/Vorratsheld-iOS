//
//  ShoppingListViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class ShoppingListViewModel {

    private let shoppingRepository: ShoppingRepository
    private let authRepository: AuthRepository

    var items: [ShoppingItem] = []
    var isLoading = true
    var errorMessage: String?

    var openItems: [ShoppingItem] {
        items.filter { !$0.checked }
    }

    var doneItems: [ShoppingItem] {
        items.filter { $0.checked }
    }

    init(shoppingRepository: ShoppingRepository, authRepository: AuthRepository) {
        self.shoppingRepository = shoppingRepository
        self.authRepository = authRepository
    }

    func fetchItems() {
        guard let userId = authRepository.currentUserId else { return }
        shoppingRepository.listenToItems(userId: userId) { items in
            self.items = items
            self.isLoading = false
        }
    }

    func stopListening() {
        shoppingRepository.stopListening()
    }

    func addItem(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let userId = authRepository.currentUserId else { return }
        do {
            try shoppingRepository.addItem(ShoppingItem(userId: userId, name: trimmed))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleChecked(_ item: ShoppingItem) {
        guard let itemId = item.id else { return }
        Task {
            do {
                try await shoppingRepository.setChecked(itemId: itemId, checked: !item.checked)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func changeQuantity(_ item: ShoppingItem, by delta: Int) {
        let quantity = min(max(item.quantity + delta, 1), 99)
        guard quantity != item.quantity, let itemId = item.id else { return }
        Task {
            do {
                try await shoppingRepository.setQuantity(itemId: itemId, quantity: quantity)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteItem(_ item: ShoppingItem) {
        guard let itemId = item.id else { return }
        Task {
            do {
                try await shoppingRepository.deleteItem(id: itemId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func clearDone() {
        for item in doneItems {
            deleteItem(item)
        }
    }
}
