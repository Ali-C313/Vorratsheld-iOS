//
//  ProductRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class ProductRepositoryMock: ProductRepository {

    private var onChange: (([Product]) -> Void)?

    private var products: [Product] = {
        let today = LocalDay.today()
        var milk = Product(userId: "preview", barcode: "4008400301012", name: "Vollmilch 1L", expiryDate: today.adding(days: 2).millis, quantity: 2, isFavorite: true)
        milk.id = "1"
        var yoghurt = Product(userId: "preview", name: "Joghurt", expiryDate: today.adding(days: -1).millis)
        yoghurt.id = "2"
        var butter = Product(userId: "preview", name: "Butter", expiryDate: today.adding(days: 8).millis)
        butter.id = "3"
        var pasta = Product(userId: "preview", name: "Nudeln", location: .kammer, expiryDate: today.adding(days: 200).millis, quantity: 3)
        pasta.id = "4"
        return [milk, yoghurt, butter, pasta]
    }()

    func listenToProducts(userId: String, onChange: @escaping ([Product]) -> Void) {
        self.onChange = onChange
        onChange(products)
    }

    func stopListening() {
        onChange = nil
    }

    func saveProduct(_ product: Product) throws {
        var saved = product
        if saved.id == nil {
            saved.id = UUID().uuidString
        }
        products.removeAll { $0.id == saved.id }
        products.append(saved)
        onChange?(products)
    }

    func updateFavorite(productId: String, isFavorite: Bool) async throws {
        if let index = products.firstIndex(where: { $0.id == productId }) {
            products[index].isFavorite = isFavorite
        }
        onChange?(products)
    }

    func deleteProduct(id: String) async throws {
        products.removeAll { $0.id == id }
        onChange?(products)
    }

    func deleteAllProducts(userId: String) async throws {
        products.removeAll()
        onChange?(products)
    }
}
