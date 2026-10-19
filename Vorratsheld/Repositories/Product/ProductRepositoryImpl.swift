//
//  ProductRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import FirebaseFirestore

class ProductRepositoryImpl: ProductRepository {

    private let database = FirebaseManager.shared.database
    private var listener: ListenerRegistration?

    private var collection: CollectionReference {
        database.collection(CollectionNames.products)
    }

    func listenToProducts(userId: String, onChange: @escaping ([Product]) -> Void) {
        guard listener == nil else { return }

        listener = collection
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("Fehler beim Abruf der Produkte: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("Fehler beim Abrufen der Produkte")
                    return
                }

                let products = documents.compactMap {
                    try? $0.data(as: Product.self)
                }
                onChange(products)
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }

    func saveProduct(_ product: Product) throws {
        let reference = product.id.map { collection.document($0) } ?? collection.document()
        // Die Android-Version liest die ID aus dem Feld "id"
        var data = try Firestore.Encoder().encode(product)
        data["id"] = reference.documentID
        reference.setData(data)
    }

    func updateFavorite(productId: String, isFavorite: Bool) async throws {
        try await collection.document(productId).updateData(["favorite": isFavorite])
    }

    func deleteProduct(id: String) async throws {
        try await collection.document(id).delete()
    }

    func deleteAllProducts(userId: String) async throws {
        let snapshot = try await collection.whereField("userId", isEqualTo: userId).getDocuments()
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
}
