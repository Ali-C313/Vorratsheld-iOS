//
//  ShoppingRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import FirebaseFirestore

class ShoppingRepositoryImpl: ShoppingRepository {

    private let database = FirebaseManager.shared.database
    private var listener: ListenerRegistration?

    private var collection: CollectionReference {
        database.collection(CollectionNames.shoppingItems)
    }

    func listenToItems(userId: String, onChange: @escaping ([ShoppingItem]) -> Void) {
        guard listener == nil else { return }

        listener = collection
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("Fehler beim Abruf der Einkaufsliste: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("Fehler beim Abrufen der Einkaufsliste")
                    return
                }

                let items = documents.compactMap {
                    try? $0.data(as: ShoppingItem.self)
                }
                onChange(items.sorted { $0.addedAt < $1.addedAt })
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }

    func addItem(_ item: ShoppingItem) throws {
        let reference = collection.document()
        // Die Android-Version liest die ID aus dem Feld "id"
        var data = try Firestore.Encoder().encode(item)
        data["id"] = reference.documentID
        reference.setData(data)
    }

    func setChecked(itemId: String, checked: Bool) async throws {
        try await collection.document(itemId).updateData(["checked": checked])
    }

    func setQuantity(itemId: String, quantity: Int) async throws {
        try await collection.document(itemId).updateData(["quantity": quantity])
    }

    func deleteItem(id: String) async throws {
        try await collection.document(id).delete()
    }

    func deleteAllItems(userId: String) async throws {
        let snapshot = try await collection.whereField("userId", isEqualTo: userId).getDocuments()
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }

    func addFromProduct(_ product: Product) async throws {
        if let existing = try await findOpenItem(for: product), let itemId = existing.id {
            try await setQuantity(itemId: itemId, quantity: existing.quantity + 1)
        } else {
            try addItem(ShoppingItem(userId: product.userId, name: product.name, imageUrl: product.imageUrl))
        }
    }

    func removeOneFromProduct(_ product: Product) async throws {
        guard let existing = try await findOpenItem(for: product), let itemId = existing.id else { return }
        if existing.quantity > 1 {
            try await setQuantity(itemId: itemId, quantity: existing.quantity - 1)
        } else {
            try await deleteItem(id: itemId)
        }
    }

    private func findOpenItem(for product: Product) async throws -> ShoppingItem? {
        let snapshot = try await collection.whereField("userId", isEqualTo: product.userId).getDocuments()
        let items = snapshot.documents.compactMap { try? $0.data(as: ShoppingItem.self) }
        return items.first { !$0.checked && $0.name.caseInsensitiveCompare(product.name) == .orderedSame }
    }
}
