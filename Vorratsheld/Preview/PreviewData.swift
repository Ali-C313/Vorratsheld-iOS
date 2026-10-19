//
//  PreviewData.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

// ViewModels mit den Mocks, damit die Previews ohne Firebase laufen
@MainActor
enum PreviewData {

    static var userViewModel: UserViewModel {
        UserViewModel(
            authRepository: AuthRepositoryMock(),
            userRepository: UserRepositoryMock(),
            productRepository: ProductRepositoryMock(),
            shoppingRepository: ShoppingRepositoryMock()
        )
    }

    static var productViewModel: ProductViewModel {
        let viewModel = ProductViewModel(
            productRepository: ProductRepositoryMock(),
            shoppingRepository: ShoppingRepositoryMock(),
            authRepository: AuthRepositoryMock()
        )
        viewModel.fetchProducts()
        return viewModel
    }

    static var productDetailViewModel: ProductDetailViewModel {
        ProductDetailViewModel(productInfoRepository: ProductInfoRepositoryMock())
    }

    static var shoppingListViewModel: ShoppingListViewModel {
        ShoppingListViewModel(shoppingRepository: ShoppingRepositoryMock(), authRepository: AuthRepositoryMock())
    }

    static var supportViewModel: SupportViewModel {
        SupportViewModel(supportRepository: SupportRepositoryMock(), authRepository: AuthRepositoryMock())
    }
}
